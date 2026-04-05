#!/bin/bash

# wallpaper-config.sh
# Rofi settings menu for the wallpaper daemon
# Reads/writes ~/.config/hypr/wallpaper-state.conf and reloads the daemon

STATE_FILE="$HOME/.config/hypr/wallpaper-state.conf"
PIPE="/tmp/wallpaper-daemon.pipe"
ROFI_THEME="$HOME/.config/rofi/space-station.rasi"

# ── State helpers ─────────────────────────────────────────────────────────────

read_state_value() {
    local key="$1"
    grep -m1 "^${key}=" "$STATE_FILE" 2>/dev/null | cut -d'=' -f2 | tr -d '"'
}

write_state_value() {
    local key="$1"
    local value="$2"

    # Determine whether the value needs quotes (non-numeric strings)
    local formatted_value
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        formatted_value="$value"
    elif [[ "$value" == "true" || "$value" == "false" ]]; then
        formatted_value="$value"
    else
        formatted_value="\"$value\""
    fi

    if grep -q "^${key}=" "$STATE_FILE" 2>/dev/null; then
        sed -i "s|^${key}=.*|${key}=${formatted_value}|" "$STATE_FILE"
    else
        echo "${key}=${formatted_value}" >> "$STATE_FILE"
    fi
}

reload_daemon() {
    if [[ -p "$PIPE" ]]; then
        echo "reload-config" > "$PIPE"
    fi
}

# ── Ensure state file exists ──────────────────────────────────────────────────

if [[ ! -f "$STATE_FILE" ]]; then
    mkdir -p "$(dirname "$STATE_FILE")"
    cat > "$STATE_FILE" <<'EOF'
WALLPAPER_MODE="random"
WALLPAPER_INTERVAL=30
WALLPAPER_PAUSED=false
WALLPAPER_AUTO_THEME=false
WALLPAPER_TRANSITION="fade"
WALLPAPER_TRANSITION_DURATION=2
EOF
fi

# ── Read current values ───────────────────────────────────────────────────────

mode=$(      read_state_value "WALLPAPER_MODE")
interval=$(  read_state_value "WALLPAPER_INTERVAL")
paused=$(    read_state_value "WALLPAPER_PAUSED")
auto_theme=$(read_state_value "WALLPAPER_AUTO_THEME")
transition=$(read_state_value "WALLPAPER_TRANSITION")
duration=$(  read_state_value "WALLPAPER_TRANSITION_DURATION")

[[ -z "$mode"       ]] && mode="random"
[[ -z "$interval"   ]] && interval="30"
[[ -z "$paused"     ]] && paused="false"
[[ -z "$auto_theme" ]] && auto_theme="false"
[[ -z "$transition" ]] && transition="fade"
[[ -z "$duration"   ]] && duration="2"

# ── Build menu ────────────────────────────────────────────────────────────────

menu_entries=$(cat <<EOF
 Set Interval         (current: ${interval}s)
 Toggle Mode          (current: ${mode})
 Toggle Auto-Theme    (current: ${auto_theme})
 Set Transition       (current: ${transition})
EOF
)

selected=$(
    printf '%s' "$menu_entries" \
        | rofi \
            -dmenu \
            -p "Wallpaper Config" \
            -theme "$ROFI_THEME" \
            -theme-str 'window { width: 650px; } listview { lines: 4; }'
)

[[ -z "$selected" ]] && exit 0

# ── Handle selection ──────────────────────────────────────────────────────────

handle_set_interval() {
    local new_interval
    new_interval=$(
        printf '' \
            | rofi \
                -dmenu \
                -p "Interval (seconds)" \
                -theme "$ROFI_THEME" \
                -theme-str 'window { width: 400px; } listview { lines: 0; }'
    )

    [[ -z "$new_interval" ]] && return

    if ! [[ "$new_interval" =~ ^[0-9]+$ ]] || [[ "$new_interval" -lt 5 ]]; then
        notify-send "Wallpaper Config" "Invalid interval: must be a number >= 5" 2>/dev/null
        return
    fi

    write_state_value "WALLPAPER_INTERVAL" "$new_interval"
    reload_daemon
    notify-send "Wallpaper Config" "Interval set to ${new_interval}s" 2>/dev/null
}

handle_toggle_mode() {
    local new_mode
    if [[ "$mode" == "random" ]]; then
        new_mode="sequential"
    else
        new_mode="random"
    fi
    write_state_value "WALLPAPER_MODE" "$new_mode"
    reload_daemon
    notify-send "Wallpaper Config" "Mode switched to $new_mode" 2>/dev/null
}

handle_toggle_auto_theme() {
    local new_auto
    if [[ "$auto_theme" == "true" ]]; then
        new_auto="false"
    else
        new_auto="true"
    fi
    write_state_value "WALLPAPER_AUTO_THEME" "$new_auto"
    reload_daemon
    notify-send "Wallpaper Config" "Auto-theme set to $new_auto" 2>/dev/null
}

handle_set_transition() {
    local new_transition
    new_transition=$(
        printf 'fade\nwipe\nnone\n' \
            | rofi \
                -dmenu \
                -p "Transition type" \
                -theme "$ROFI_THEME" \
                -theme-str 'window { width: 400px; } listview { lines: 3; }'
    )

    [[ -z "$new_transition" ]] && return

    write_state_value "WALLPAPER_TRANSITION" "$new_transition"
    reload_daemon
    notify-send "Wallpaper Config" "Transition set to $new_transition" 2>/dev/null
}

case "$selected" in
    *"Set Interval"*)
        handle_set_interval
        ;;
    *"Toggle Mode"*)
        handle_toggle_mode
        ;;
    *"Toggle Auto-Theme"*)
        handle_toggle_auto_theme
        ;;
    *"Set Transition"*)
        handle_set_transition
        ;;
esac
