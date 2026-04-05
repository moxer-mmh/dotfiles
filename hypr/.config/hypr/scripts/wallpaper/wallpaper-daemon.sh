#!/bin/bash

# wallpaper-daemon.sh
# Named-pipe based wallpaper daemon for Hyprland
# Replaces wallpaper-cycle.sh with full command support

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="$HOME/.config/hypr/wallpaper-state.conf"
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"
PIPE="/tmp/wallpaper-daemon.pipe"
LOG="/tmp/wallpaper-daemon.log"

# ── Logging ──────────────────────────────────────────────────────────────────

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
}

# ── State management ─────────────────────────────────────────────────────────

load_state() {
    MODE="random"
    INTERVAL=30
    PAUSED=false
    AUTO_THEME=false
    TRANSITION="fade"
    TRANSITION_DURATION=2

    if [[ -f "$STATE_FILE" ]]; then
        # Source the state file, mapping WALLPAPER_* keys to local vars
        local _mode _interval _paused _auto_theme _transition _duration
        _mode=$(      grep -m1 '^WALLPAPER_MODE='              "$STATE_FILE" | cut -d'"' -f2)
        _interval=$(  grep -m1 '^WALLPAPER_INTERVAL='          "$STATE_FILE" | cut -d'=' -f2 | tr -d '"')
        _paused=$(    grep -m1 '^WALLPAPER_PAUSED='            "$STATE_FILE" | cut -d'=' -f2 | tr -d '"')
        _auto_theme=$(grep -m1 '^WALLPAPER_AUTO_THEME='        "$STATE_FILE" | cut -d'=' -f2 | tr -d '"')
        _transition=$(grep -m1 '^WALLPAPER_TRANSITION='        "$STATE_FILE" | cut -d'"' -f2)
        _duration=$(  grep -m1 '^WALLPAPER_TRANSITION_DURATION=' "$STATE_FILE" | cut -d'=' -f2 | tr -d '"')

        [[ -n "$_mode"       ]] && MODE="$_mode"
        [[ -n "$_interval"   ]] && INTERVAL="$_interval"
        [[ -n "$_paused"     ]] && PAUSED="$_paused"
        [[ -n "$_auto_theme" ]] && AUTO_THEME="$_auto_theme"
        [[ -n "$_transition" ]] && TRANSITION="$_transition"
        [[ -n "$_duration"   ]] && TRANSITION_DURATION="$_duration"
    fi

    log "State loaded: MODE=$MODE INTERVAL=$INTERVAL PAUSED=$PAUSED AUTO_THEME=$AUTO_THEME TRANSITION=$TRANSITION DURATION=$TRANSITION_DURATION"
}

# ── Wallpaper list ────────────────────────────────────────────────────────────

load_wallpapers() {
    mapfile -t WALLPAPERS < <(
        find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort
    )

    if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
        log "ERROR: No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi

    log "Loaded ${#WALLPAPERS[@]} wallpapers from $WALLPAPER_DIR"

    if [[ "$MODE" == "random" ]]; then
        mapfile -t WALLPAPERS < <(printf '%s\n' "${WALLPAPERS[@]}" | shuf)
    fi

    CURRENT_INDEX=0
}

# ── Apply wallpaper ───────────────────────────────────────────────────────────

apply_wallpaper() {
    local wallpaper="$1"

    if [[ ! -f "$wallpaper" ]]; then
        log "ERROR: Wallpaper file not found: $wallpaper"
        return 1
    fi

    log "Applying wallpaper: $wallpaper"

    awww img "$wallpaper" \
        --transition-type "$TRANSITION" \
        --transition-duration "$TRANSITION_DURATION" \
        >> "$LOG" 2>&1

    ln -sf "$wallpaper" "$CURRENT_WALLPAPER"

    # Notify hyprlock to reload the wallpaper
    pkill -USR2 hyprlock 2>/dev/null

    # Apply theme if enabled
    if [[ "$AUTO_THEME" == "true" ]]; then
        local theme_script="$HOME/.config/theme/scripts/apply-theme.sh"
        if [[ -x "$theme_script" ]]; then
            "$theme_script" wallpaper >> "$LOG" 2>&1 &
        else
            log "WARNING: AUTO_THEME=true but $theme_script not found or not executable"
        fi
    fi
}

# ── Navigation helpers ────────────────────────────────────────────────────────

next_wallpaper() {
    CURRENT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

    # Re-shuffle on wrap-around in random mode
    if [[ $CURRENT_INDEX -eq 0 && "$MODE" == "random" ]]; then
        mapfile -t WALLPAPERS < <(printf '%s\n' "${WALLPAPERS[@]}" | shuf)
        log "Re-shuffled wallpaper list"
    fi

    apply_wallpaper "${WALLPAPERS[$CURRENT_INDEX]}"
}

prev_wallpaper() {
    CURRENT_INDEX=$(( (CURRENT_INDEX - 1 + ${#WALLPAPERS[@]}) % ${#WALLPAPERS[@]} ))
    apply_wallpaper "${WALLPAPERS[$CURRENT_INDEX]}"
}

# ── Pipe setup ────────────────────────────────────────────────────────────────

setup_pipe() {
    if [[ ! -p "$PIPE" ]]; then
        mkfifo "$PIPE"
        log "Created named pipe at $PIPE"
    fi
}

# ── Status output ─────────────────────────────────────────────────────────────

status_json() {
    local current_name=""
    if [[ -L "$CURRENT_WALLPAPER" ]]; then
        current_name=$(basename "$(readlink -f "$CURRENT_WALLPAPER")" 2>/dev/null)
    fi

    local class="cycling"
    [[ "$PAUSED" == "true" ]] && class="paused"

    local icon=""
    [[ "$PAUSED" == "true" ]] && icon=""

    printf '{"text":"%s %s","class":"%s","tooltip":"Mode: %s | Interval: %ss | Transition: %s\nWallpaper: %s"}\n' \
        "$icon" "$current_name" "$class" "$MODE" "$INTERVAL" "$TRANSITION" \
        "$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null)"
}

# ── Command handler ───────────────────────────────────────────────────────────

handle_command() {
    local cmd="$1"
    local arg="$2"

    log "Received command: $cmd $arg"

    case "$cmd" in
        next)
            next_wallpaper
            ;;
        prev)
            prev_wallpaper
            ;;
        set)
            if [[ -z "$arg" ]]; then
                log "ERROR: 'set' command requires a path argument"
                return
            fi
            # Find the index in the array so navigation stays consistent
            local i
            for i in "${!WALLPAPERS[@]}"; do
                if [[ "${WALLPAPERS[$i]}" == "$arg" ]]; then
                    CURRENT_INDEX=$i
                    break
                fi
            done
            apply_wallpaper "$arg"
            ;;
        toggle-pause)
            if [[ "$PAUSED" == "true" ]]; then
                PAUSED=false
                log "Daemon unpaused"
            else
                PAUSED=true
                log "Daemon paused"
            fi
            ;;
        status)
            status_json >> "$LOG"
            ;;
        reload-config)
            load_state
            load_wallpapers
            ;;
        quit)
            log "Received quit command, exiting"
            cleanup
            exit 0
            ;;
        *)
            log "WARNING: Unknown command: $cmd"
            ;;
    esac
}

# ── Cleanup ───────────────────────────────────────────────────────────────────

cleanup() {
    log "Daemon shutting down"
    [[ -p "$PIPE" ]] && rm -f "$PIPE"
}

trap cleanup EXIT SIGTERM SIGINT

# ── Main loop ─────────────────────────────────────────────────────────────────

main() {
    log "=== Wallpaper daemon starting ==="

    if ! command -v awww &>/dev/null; then
        log "ERROR: awww not found in PATH"
        exit 1
    fi

    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        log "ERROR: Wallpaper directory does not exist: $WALLPAPER_DIR"
        exit 1
    fi

    setup_pipe
    load_state
    load_wallpapers || exit 1

    # Set the first wallpaper immediately
    apply_wallpaper "${WALLPAPERS[$CURRENT_INDEX]}"

    # Open the pipe read+write on fd 3 so read -t timeout works
    # (a FIFO blocks on read until a writer opens it; holding a write fd prevents that)
    exec 3<>"$PIPE"

    while true; do
        local line cmd arg
        if IFS= read -r -t "$INTERVAL" line <&3 2>/dev/null; then
            cmd=$(echo "$line" | awk '{print $1}')
            arg=$(echo "$line" | cut -s -d' ' -f2-)
            handle_command "$cmd" "$arg"
        else
            # Timeout: advance to next wallpaper unless paused
            if [[ "$PAUSED" != "true" ]]; then
                next_wallpaper
            fi
        fi
    done
}

main "$@"
