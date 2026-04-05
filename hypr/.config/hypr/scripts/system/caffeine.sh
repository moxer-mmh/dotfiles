#!/bin/bash
# caffeine.sh — Toggle hypridle to inhibit idle/sleep
# Part of the Hyprland Space Station setup
#
# Caffeine ON  = hypridle killed   (idle inhibited)
# Caffeine OFF = hypridle running  (idle allowed)
#
# Args:
#   toggle  (default) — Flip caffeine state
#   status  — Output JSON for waybar

STATE_FILE="/tmp/caffeine.state"

load_state() {
    CAFFEINE_ACTIVE="false"
    if [[ -f "$STATE_FILE" ]]; then
        # shellcheck source=/dev/null
        source "$STATE_FILE" 2>/dev/null || true
    fi
}

save_state() {
    printf 'CAFFEINE_ACTIVE=%s\n' "$CAFFEINE_ACTIVE" > "$STATE_FILE"
}

is_hypridle_running() {
    pgrep -x hypridle &>/dev/null
}

do_toggle() {
    load_state

    if is_hypridle_running; then
        # hypridle running → caffeine is OFF → turn ON (kill hypridle)
        pkill -x hypridle 2>/dev/null || true
        CAFFEINE_ACTIVE="true"
        save_state
    else
        # hypridle not running → caffeine is ON → turn OFF (start hypridle)
        if command -v hypridle &>/dev/null; then
            hypridle &>/dev/null &
            disown
        fi
        CAFFEINE_ACTIVE="false"
        save_state
    fi
}

do_status() {
    load_state

    # Sync: if hypridle is running, caffeine is inactive
    if is_hypridle_running; then
        CAFFEINE_ACTIVE="false"
    else
        CAFFEINE_ACTIVE="true"
    fi

    local icon class tooltip
    if [[ "$CAFFEINE_ACTIVE" == "true" ]]; then
        icon="󰅶"
        class="active"
        tooltip="Caffeine: ON (idle inhibited)"
    else
        icon="󰾪"
        class="inactive"
        tooltip="Caffeine: OFF (idle allowed)"
    fi

    tooltip="${tooltip//\"/\\\"}"
    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
        "$icon" "$class" "$tooltip"
}

ARG="${1:-toggle}"

case "$ARG" in
    toggle)     do_toggle ;;
    status)     do_status ;;
    *)          do_status ;;
esac
