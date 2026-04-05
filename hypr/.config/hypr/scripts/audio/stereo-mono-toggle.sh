#!/usr/bin/env bash
# stereo-mono-toggle.sh — Toggle between stereo and mono audio output
#
# Usage:
#   stereo-mono-toggle.sh toggle   — toggle stereo/mono
#   stereo-mono-toggle.sh status   — print waybar JSON
#
# State is persisted in /tmp/audio-mono.state

STATE_FILE="/tmp/audio-mono.state"
ORIGINAL_SINK_FILE="/tmp/audio-mono-original-sink.state"
MODULE_ID_FILE="/tmp/audio-mono-module-id.state"

ICON_STEREO="󰓃"
ICON_MONO="󰖁"

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

notify() {
    local summary="$1"
    local body="$2"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Audio" -i "audio-speakers" "$summary" "$body"
    fi
}

get_state() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "stereo"
    fi
}

print_status() {
    local state
    state=$(get_state)
    if [[ "$state" == "mono" ]]; then
        printf '{"text": "%s", "tooltip": "Mono output active", "class": "mono"}\n' "$ICON_MONO"
    else
        printf '{"text": "%s", "tooltip": "Stereo output active", "class": "stereo"}\n' "$ICON_STEREO"
    fi
}

enable_mono() {
    local default_sink
    default_sink=$(pactl get-default-sink)

    # Don't stack mono on top of mono
    if [[ "$default_sink" == "mono" ]]; then
        echo "stereo" > "$STATE_FILE"
        return
    fi

    # Save original sink for restoration
    echo "$default_sink" > "$ORIGINAL_SINK_FILE"

    # Load the remap-sink module
    module_id=$(pactl load-module module-remap-sink \
        sink_name=mono \
        sink_properties=device.description=Mono \
        master="$default_sink" \
        channels=2 \
        channel_map=mono,mono \
        2>/dev/null)

    if [[ -z "$module_id" ]]; then
        notify "Mono Toggle" "Failed to load mono module."
        exit 1
    fi

    echo "$module_id" > "$MODULE_ID_FILE"

    # Give PipeWire a moment to register the new sink
    sleep 0.3

    pactl set-default-sink mono

    # Move all existing streams to mono sink
    while IFS= read -r stream_id; do
        [[ -z "$stream_id" ]] && continue
        pactl move-sink-input "$stream_id" mono
    done < <(pactl list sink-inputs short | awk '{print $1}')

    echo "mono" > "$STATE_FILE"
    notify "Audio" "Mono output enabled"
}

disable_mono() {
    local original_sink=""
    local module_id=""

    [[ -f "$ORIGINAL_SINK_FILE" ]] && original_sink=$(cat "$ORIGINAL_SINK_FILE")
    [[ -f "$MODULE_ID_FILE" ]]     && module_id=$(cat "$MODULE_ID_FILE")

    # Determine the sink to restore to
    if [[ -z "$original_sink" ]]; then
        # Fall back: pick first non-mono sink
        original_sink=$(pactl list sinks short | awk '{print $2}' | grep -v '^mono$' | head -1)
    fi

    if [[ -n "$original_sink" ]]; then
        pactl set-default-sink "$original_sink"

        # Move streams back before unloading the module
        while IFS= read -r stream_id; do
            [[ -z "$stream_id" ]] && continue
            pactl move-sink-input "$stream_id" "$original_sink"
        done < <(pactl list sink-inputs short | awk '{print $1}')
    fi

    # Unload module
    if [[ -n "$module_id" ]]; then
        pactl unload-module "$module_id" 2>/dev/null
    else
        # Try to unload by finding the module dynamically
        existing_id=$(pactl list modules short | \
            awk '$2 == "module-remap-sink" {print $1}' | head -1)
        [[ -n "$existing_id" ]] && pactl unload-module "$existing_id" 2>/dev/null
    fi

    # Clean up state files
    rm -f "$STATE_FILE" "$ORIGINAL_SINK_FILE" "$MODULE_ID_FILE"

    notify "Audio" "Stereo output restored"
}

do_toggle() {
    local state
    state=$(get_state)

    if [[ "$state" == "mono" ]]; then
        disable_mono
    else
        enable_mono
    fi
}

# --------------------------------------------------------------------------- #
# Entrypoint
# --------------------------------------------------------------------------- #

ACTION="${1:-status}"

case "$ACTION" in
    toggle)
        do_toggle
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
