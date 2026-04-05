#!/usr/bin/env bash
# gamemode.sh — Toggle Hyprland performance mode
# Part of the Hyprland Space Station setup
#
# Game Mode ON:  disables blur, animations, gaps (max performance)
# Game Mode OFF: restores blur, animations, gaps (normal appearance)
#
# Args:
#   toggle  (default) — Flip game mode state
#   status  — Output JSON for waybar

STATE_FILE="/tmp/gamemode.state"

get_state() {
    if [[ -f "$STATE_FILE" ]]; then
        # shellcheck source=/dev/null
        source "$STATE_FILE" 2>/dev/null || true
        echo "${ENABLED:-false}"
    else
        echo "false"
    fi
}

cmd_toggle() {
    local current
    current=$(get_state)

    if [[ "$current" == "false" ]]; then
        hyprctl --batch \
            "keyword decoration:blur:enabled false ; \
             keyword animations:enabled false ; \
             keyword general:gaps_in 0 ; \
             keyword general:gaps_out 0 ; \
             keyword general:border_size 2"
        echo "ENABLED=true" > "$STATE_FILE"
        notify-send -i applications-games "Game Mode" "Game Mode: ON — performance optimized" -t 3000
    else
        hyprctl --batch \
            "keyword decoration:blur:enabled true ; \
             keyword animations:enabled true ; \
             keyword general:gaps_in 12 ; \
             keyword general:gaps_out 20 ; \
             keyword general:border_size 4"
        echo "ENABLED=false" > "$STATE_FILE"
        notify-send -i applications-games "Game Mode" "Game Mode: OFF — normal mode restored" -t 3000
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

ARG="${1:-toggle}"

case "$ARG" in
    toggle) cmd_toggle ;;
    status) cmd_status ;;
    *)      cmd_status ;;
esac
