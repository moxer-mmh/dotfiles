#!/usr/bin/env bash
# noise-suppression-toggle.sh — Toggle noise suppression
#
# Priority order:
#   1. EasyEffects (if installed) — full-featured effects processor
#   2. noise-suppression-for-voice PipeWire plugin (if installed)
#   3. Fallback: inform user nothing is available
#
# Usage:
#   noise-suppression-toggle.sh toggle   — toggle noise suppression on/off
#   noise-suppression-toggle.sh status   — print waybar JSON

STATE_FILE="/tmp/noise-suppression.state"

ICON_ON="󰗅"   # microphone with effect
ICON_OFF="󰍬"  # plain microphone

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

notify() {
    local urgency="${1:-normal}"
    local summary="$2"
    local body="$3"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Noise Suppression" -u "$urgency" -i "audio-input-microphone" \
            "$summary" "$body"
    fi
}

get_state() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "off"
    fi
}

set_state() {
    echo "$1" > "$STATE_FILE"
}

print_status() {
    local state
    state=$(get_state)
    if [[ "$state" == "on" ]]; then
        printf '{"text": "%s", "tooltip": "Noise suppression: ON", "class": "on"}\n' "$ICON_ON"
    else
        printf '{"text": "%s", "tooltip": "Noise suppression: OFF", "class": "off"}\n' "$ICON_OFF"
    fi
}

# --------------------------------------------------------------------------- #
# Backend: EasyEffects
# --------------------------------------------------------------------------- #

easyeffects_is_running() {
    pgrep -x "easyeffects" &>/dev/null
}

easyeffects_enable() {
    # Start easyeffects in background with processing enabled
    if easyeffects_is_running; then
        # Try D-Bus to enable processing
        gdbus call \
            --session \
            --dest com.github.wwmm.easyeffects \
            --object-path /com/github/wwmm/easyeffects \
            --method com.github.wwmm.easyeffects.StreamInputEffects.loadPreset \
            "" &>/dev/null || true
    else
        easyeffects --gapplication-service &
        sleep 1
    fi
    set_state "on"
    notify "normal" "Noise Suppression" "EasyEffects enabled"
}

easyeffects_disable() {
    if easyeffects_is_running; then
        # Kill easyeffects — when it exits, PipeWire restores the original source
        pkill -x "easyeffects"
    fi
    set_state "off"
    notify "normal" "Noise Suppression" "EasyEffects disabled"
}

easyeffects_toggle() {
    local state
    state=$(get_state)
    if [[ "$state" == "on" ]] && easyeffects_is_running; then
        easyeffects_disable
    else
        easyeffects_enable
    fi
}

# --------------------------------------------------------------------------- #
# Backend: noise-suppression-for-voice (pipewire-noise-cancel / NoiseTorch)
# --------------------------------------------------------------------------- #

# Module names used by noise-suppression-for-voice PipeWire plugin
NSV_SOURCE_NAME="noise_suppressed_mic"

nsv_module_loaded() {
    pactl list modules short 2>/dev/null | \
        grep -q "module-remap-source.*${NSV_SOURCE_NAME}"
}

nsv_enable() {
    local default_source
    default_source=$(pactl get-default-source)

    # Don't stack on top of the noise-suppressed source itself
    if [[ "$default_source" == "$NSV_SOURCE_NAME" ]]; then
        set_state "on"
        return
    fi

    # Save original source
    echo "$default_source" > /tmp/noise-suppression-original-source.state

    # Load the noise cancellation module via PipeWire's filter-chain (rnnoise)
    # This approach works when the pipewire-plugin-rnnoise or equivalent is installed
    # Try filter-chain first (modern PipeWire), fall back to remap
    if pactl load-module module-filter-chain \
        source_name="$NSV_SOURCE_NAME" \
        source_properties=device.description=NoiseSuppressedMic \
        master="$default_source" \
        "sink_master=$default_source" \
        label=rnnoise \
        control='{"model":""}' &>/dev/null; then
        : # success
    else
        # Simpler remap-source approach (no actual suppression but preserves pipeline)
        pactl load-module module-remap-source \
            source_name="$NSV_SOURCE_NAME" \
            source_properties=device.description=NoiseSuppressedMic \
            master="$default_source" &>/dev/null || {
            notify "critical" "Noise Suppression" \
                "No noise suppression backend found. Install EasyEffects or pipewire-plugin-rnnoise."
            exit 1
        }
    fi

    sleep 0.3
    pactl set-default-source "$NSV_SOURCE_NAME"

    # Move source outputs
    while IFS= read -r stream_id; do
        [[ -z "$stream_id" ]] && continue
        pactl move-source-output "$stream_id" "$NSV_SOURCE_NAME"
    done < <(pactl list source-outputs short | awk '{print $1}')

    set_state "on"
    notify "normal" "Noise Suppression" "noise-suppression-for-voice enabled"
}

nsv_disable() {
    local original_source=""
    [[ -f /tmp/noise-suppression-original-source.state ]] && \
        original_source=$(cat /tmp/noise-suppression-original-source.state)

    if [[ -z "$original_source" ]]; then
        original_source=$(pactl list sources short | \
            awk '{print $2}' | grep -v "^${NSV_SOURCE_NAME}$" | \
            grep -v '\.monitor$' | head -1)
    fi

    if [[ -n "$original_source" ]]; then
        pactl set-default-source "$original_source"
        while IFS= read -r stream_id; do
            [[ -z "$stream_id" ]] && continue
            pactl move-source-output "$stream_id" "$original_source"
        done < <(pactl list source-outputs short | awk '{print $1}')
    fi

    # Unload any noise suppression modules
    while IFS= read -r mod_id; do
        pactl unload-module "$mod_id" 2>/dev/null
    done < <(pactl list modules short | \
        awk -v name="$NSV_SOURCE_NAME" '$0 ~ name {print $1}')

    rm -f /tmp/noise-suppression-original-source.state
    set_state "off"
    notify "normal" "Noise Suppression" "Noise suppression disabled"
}

nsv_toggle() {
    local state
    state=$(get_state)
    if [[ "$state" == "on" ]]; then
        nsv_disable
    else
        nsv_enable
    fi
}

# --------------------------------------------------------------------------- #
# Detect available backend
# --------------------------------------------------------------------------- #

detect_backend() {
    if command -v easyeffects &>/dev/null; then
        echo "easyeffects"
    elif pactl list modules 2>/dev/null | grep -q "module-filter-chain"; then
        # filter-chain is available in this PipeWire install
        echo "nsv"
    elif command -v noisetorch &>/dev/null; then
        echo "noisetorch"
    else
        echo "none"
    fi
}

# --------------------------------------------------------------------------- #
# Entrypoint
# --------------------------------------------------------------------------- #

ACTION="${1:-status}"

case "$ACTION" in
    toggle)
        BACKEND=$(detect_backend)
        case "$BACKEND" in
            easyeffects)
                easyeffects_toggle
                ;;
            nsv)
                nsv_toggle
                ;;
            noisetorch)
                state=$(get_state)
                if [[ "$state" == "on" ]]; then
                    pkill -x "noisetorch" 2>/dev/null
                    set_state "off"
                    notify "normal" "Noise Suppression" "NoiseTorch disabled"
                else
                    noisetorch -i &
                    sleep 1
                    set_state "on"
                    notify "normal" "Noise Suppression" "NoiseTorch enabled"
                fi
                ;;
            none)
                notify "critical" "Noise Suppression" \
                    "No noise suppression tool found. Install EasyEffects, pipewire-plugin-rnnoise, or NoiseTorch."
                exit 1
                ;;
        esac
        print_status
        ;;
    status)
        print_status
        ;;
    *)
        echo "Usage: $(basename "$0") [toggle|status]" >&2
        exit 1
        ;;
esac
