#!/bin/bash

# wallpaper-control.sh
# CLI client for wallpaper-daemon.sh
# Sends commands via the named pipe and reads status from state files

PIPE="/tmp/wallpaper-daemon.pipe"
STATE_FILE="$HOME/.config/hypr/wallpaper-state.conf"
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"

# ── Helpers ───────────────────────────────────────────────────────────────────

send_command() {
    if [[ ! -p "$PIPE" ]]; then
        echo "ERROR: Wallpaper daemon is not running (pipe not found at $PIPE)" >&2
        exit 1
    fi
    echo "$*" > "$PIPE"
}

# ── Status output ─────────────────────────────────────────────────────────────

cmd_status() {
    local current_path current_name
    current_path=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null)
    current_name=$(basename "$current_path" 2>/dev/null)

    # Read state file values
    local mode interval paused transition
    mode=$(      grep -m1 '^WALLPAPER_MODE='     "$STATE_FILE" 2>/dev/null | cut -d'"' -f2)
    interval=$(  grep -m1 '^WALLPAPER_INTERVAL=' "$STATE_FILE" 2>/dev/null | cut -d'=' -f2 | tr -d '"')
    paused=$(    grep -m1 '^WALLPAPER_PAUSED='   "$STATE_FILE" 2>/dev/null | cut -d'=' -f2 | tr -d '"')
    transition=$(grep -m1 '^WALLPAPER_TRANSITION=' "$STATE_FILE" 2>/dev/null | cut -d'"' -f2)

    [[ -z "$mode"       ]] && mode="random"
    [[ -z "$interval"   ]] && interval="30"
    [[ -z "$paused"     ]] && paused="false"
    [[ -z "$transition" ]] && transition="fade"

    local class icon
    if [[ "$paused" == "true" ]]; then
        class="paused"
        icon=""
    else
        class="cycling"
        icon=""
    fi

    local tooltip
    tooltip="Mode: $mode | Interval: ${interval}s | Transition: $transition"
    [[ -n "$current_path" ]] && tooltip="$tooltip\nWallpaper: $current_path"

    printf '{"text":"%s %s","class":"%s","tooltip":"%s"}\n' \
        "$icon" "$current_name" "$class" "$tooltip"
}

# ── Config display ────────────────────────────────────────────────────────────

cmd_config() {
    if [[ ! -f "$STATE_FILE" ]]; then
        echo "State file not found: $STATE_FILE" >&2
        exit 1
    fi
    cat "$STATE_FILE"
}

# ── Entry point ───────────────────────────────────────────────────────────────

usage() {
    cat <<EOF
Usage: $(basename "$0") <command> [args]

Commands:
  next            Advance to the next wallpaper
  prev            Go back to the previous wallpaper
  random          Pick and set a random wallpaper immediately
  toggle-pause    Pause or resume automatic cycling
  set <path>      Set a specific wallpaper by full path
  status          Print JSON status (for waybar integration)
  config          Print the current state file
EOF
}

case "$1" in
    next)
        send_command "next"
        ;;
    prev)
        send_command "prev"
        ;;
    random)
        # Pick a random file and send it as a set command
        WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
        random_wall=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n1)
        if [[ -z "$random_wall" ]]; then
            echo "ERROR: No wallpapers found in $WALLPAPER_DIR" >&2
            exit 1
        fi
        send_command "set $random_wall"
        ;;
    toggle-pause)
        send_command "toggle-pause"
        ;;
    set)
        if [[ -z "$2" ]]; then
            echo "ERROR: 'set' requires a path argument" >&2
            exit 1
        fi
        send_command "set $2"
        ;;
    status)
        cmd_status
        ;;
    config)
        cmd_config
        ;;
    ""|--help|-h)
        usage
        ;;
    *)
        echo "ERROR: Unknown command: $1" >&2
        usage
        exit 1
        ;;
esac
