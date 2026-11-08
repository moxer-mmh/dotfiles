#!/usr/bin/env bash

STATE_FILE="/tmp/gamemode.state"

get_state() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"
        echo "${ENABLED:-false}"
    else
        echo "false"
    fi
}

cmd_toggle() {
    local current
    current=$(get_state)

    if [[ "$current" == "false" ]]; then
        # hyprctl keyword is gone since Hyprland 0.57: options are set via Lua.
        hyprctl eval 'hl.config({
            decoration = { blur = { enabled = false } },
            animations = { enabled = false },
            general    = { gaps_in = 0, gaps_out = 0, border_size = 2 },
        })' >/dev/null
        echo "ENABLED=true" > "$STATE_FILE"
        notify-send -i applications-games "Game Mode" "Game Mode: ON" -t 3000
    else
        # Reloading restores every value from the config (and the theme),
        # instead of hardcoding them a second time here.
        hyprctl reload >/dev/null
        echo "ENABLED=false" > "$STATE_FILE"
        notify-send -i applications-games "Game Mode" "Game Mode: OFF" -t 3000
    fi
}

cmd_status() {
    local current
    current=$(get_state)

    if [[ "$current" == "true" ]]; then
        printf '{"text": "󰊴", "class": "on", "tooltip": "Game Mode: ON"}\n'
    else
        printf '{"text": "󰊖", "class": "off", "tooltip": "Game Mode: OFF"}\n'
    fi
}

case "$1" in
    toggle) cmd_toggle ;;
    status) cmd_status ;;
    *)
        echo "Usage: $0 {toggle|status}" >&2
        exit 1
        ;;
esac
