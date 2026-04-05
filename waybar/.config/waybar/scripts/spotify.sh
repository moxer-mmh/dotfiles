#!/bin/bash
# Waybar Spotify module — shows current track via playerctl

get_status() {
    local status artist title
    status=$(playerctl -p spotify status 2>/dev/null)

    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        artist=$(playerctl -p spotify metadata artist 2>/dev/null)
        title=$(playerctl -p spotify metadata title 2>/dev/null)

        if [[ -n "$title" ]]; then
            local icon="󰏤"
            [[ "$status" == "Playing" ]] && icon="󰐊"
            local class="playing"
            [[ "$status" == "Paused" ]] && class="paused"

            printf '{"text": "󰎇 %s %s - %s", "class": "%s", "tooltip": "%s by %s"}\n' \
                "$icon" "$artist" "$title" "$class" "$title" "$artist"
        else
            printf '{"text": "󰎇 Spotify", "class": "stopped"}\n'
        fi
    else
        printf '{"text": "", "class": "stopped"}\n'
    fi
}

# Initial output
get_status

# Follow playerctl events for real-time updates
playerctl -p spotify --follow status 2>/dev/null | while read -r _; do
    get_status
done
