#!/bin/bash
set -euo pipefail

main() {
    if ! command -v swaync-client &>/dev/null; then
        printf '{"text": "󰂚", "class": "empty", "tooltip": "swaync not available"}\n'
        return
    fi

    local dnd="false"
    local count=0

    # Get DND status
    dnd=$(swaync-client -D 2>/dev/null || echo "false")
    # Normalize: swaync-client -D outputs "true" or "false"
    dnd="${dnd//[[:space:]]/}"

    # Get notification count
    count=$(swaync-client -c 2>/dev/null || echo "0")
    count="${count//[[:space:]]/}"
    # Ensure it's a number
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        count=0
    fi

    local result
    if [[ "$dnd" == "true" ]]; then
        result='{"text": "󰂛", "class": "dnd", "tooltip": "Do Not Disturb: ON"}'
    elif (( count > 0 )); then
        result=$(printf '{"text": "󰂚 %d", "class": "unread", "tooltip": "%d unread notification(s)"}' \
            "$count" "$count")
    else
        result='{"text": "󰂚", "class": "empty", "tooltip": "No notifications"}'
    fi

    echo "$result"
}

main
