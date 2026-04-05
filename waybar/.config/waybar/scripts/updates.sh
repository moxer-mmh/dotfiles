#!/bin/bash

CACHE_FILE="$HOME/.cache/waybar-updates"
CACHE_TTL=300  # 5 minutes

main() {
    local now
    now=$(date +%s)

    # Check cache freshness
    if [[ -f "$CACHE_FILE" ]]; then
        local cached_time
        cached_time=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
        local age=$(( now - cached_time ))
        if (( age < CACHE_TTL )); then
            cat "$CACHE_FILE"
            return
        fi
    fi

    local packages=""

    # Try checkupdates first (from pacman-contrib)
    if command -v checkupdates &>/dev/null; then
        packages=$(checkupdates 2>/dev/null || true)
    elif command -v pacman &>/dev/null; then
        # Fallback: use pacman -Qu (requires root-free sync db)
        packages=$(pacman -Qu 2>/dev/null || true)
    fi

    local count=0
    local result

    if [[ -n "$packages" ]]; then
        count=$(echo "$packages" | grep -c . || true)
    fi

    if (( count > 0 )); then
        # Build tooltip with first 10 package names
        local tooltip_lines
        tooltip_lines=$(echo "$packages" | head -10 | awk '{print $1}' | tr '\n' '\n')
        if (( count > 10 )); then
            tooltip_lines="${tooltip_lines}... and $((count - 10)) more"
        fi
        # Escape newlines for JSON
        local tooltip
        tooltip=$(echo "$tooltip_lines" | head -10 | awk '{print $1}')
        local pkg_list
        pkg_list=$(echo "$packages" | head -10 | awk '{print $1}' | paste -sd '\n' -)
        local tooltip_json
        tooltip_json=$(printf '%s packages available:\n%s' "$count" "$pkg_list")
        if (( count > 10 )); then
            tooltip_json="${tooltip_json}\n... and $((count - 10)) more"
        fi
        # Escape for JSON string
        tooltip_json="${tooltip_json//\\/\\\\}"
        tooltip_json="${tooltip_json//\"/\\\"}"
        tooltip_json="${tooltip_json//$'\n'/\\n}"

        result=$(printf '{"text": "󰏔 %d", "class": "updates", "tooltip": "%s"}' \
            "$count" "$tooltip_json")
    else
        result='{"text": "", "class": "up-to-date", "tooltip": "System is up to date"}'
    fi

    echo "$result" > "$CACHE_FILE"
    echo "$result"
}

main
