#!/bin/bash
# System controls dropdown — vim keys: j/k navigate, l/Enter select, q/Esc close

# ── Status checks ──────────────────────────────────────────
pgrep -x wlsunset &>/dev/null && nl="ON" || nl="OFF"
pgrep -x hypridle &>/dev/null && caf="OFF" || caf="ON"
pgrep -f wf-recorder &>/dev/null && rec="REC" || rec="OFF"

if command -v gamemoded &>/dev/null && gamemoded -s 2>/dev/null | grep -q "active"; then
    gm="ON"
else
    gm="OFF"
fi

bright_cur=$(brightnessctl g 2>/dev/null)
bright_max=$(brightnessctl m 2>/dev/null)
if [[ -n "$bright_cur" && -n "$bright_max" && "$bright_max" -gt 0 ]]; then
    bright=$((bright_cur * 100 / bright_max))
else
    bright="N/A"
fi

# Wallpaper
wp_name="—"
if [[ -L "$HOME/.config/hypr/current_wallpaper" ]]; then
    wp_name=$(basename "$(readlink -f "$HOME/.config/hypr/current_wallpaper")" 2>/dev/null)
    wp_name="${wp_name%.*}"  # strip extension
    [[ ${#wp_name} -gt 25 ]] && wp_name="${wp_name:0:22}..."
fi
pgrep -f wallpaper-daemon &>/dev/null && wp_cycle="Cycling" || wp_cycle="Stopped"

# Theme
current_theme="—"
if [[ -f "$HOME/.config/theme/colors/current.conf" ]]; then
    current_theme=$(grep '^THEME_NAME=' "$HOME/.config/theme/colors/current.conf" 2>/dev/null | cut -d'"' -f2)
    [[ -z "$current_theme" ]] && current_theme="custom"
fi

# ── Build menu ─────────────────────────────────────────────
declare -A actions
idx=0
add() { options+=("$1"); actions[$idx]="$2"; ((idx++)); }

options=()
add "  TOGGLES"                    "noop"
add "󰖔  Night Light: $nl"         "nightlight"
add "󰛊  Caffeine: $caf"           "caffeine"
add "󰊴  Game Mode: $gm"           "gamemode"
add "󰑋  Recording: $rec"          "screenrecord"
add ""                             "noop"
add "  APPEARANCE"                 "noop"
add "󰸉  Theme: $current_theme"    "theme-picker"
add "󰸏  Wallpaper: $wp_name"      "wallpaper-picker"
add "󰒍  Next Wallpaper"           "wallpaper-next"
add "󰐊  Cycle: $wp_cycle"         "wallpaper-toggle"
add ""                             "noop"
add "  TOOLS"                      "noop"
add "󰃟  Brightness: ${bright}%"   "noop"
add "󰃠  Bright +10"               "bright-up"
add "󰃞  Bright -10"               "bright-down"
add "󰹑  Screenshot"               "screenshot"
add "󰏘  Color Picker"             "colorpicker"
add "󰌌  Keybind Hints"            "keybinds"

choice_idx=$(printf '%s\n' "${options[@]}" | rofi -dmenu -theme ~/.config/rofi/dropdown.rasi -p "󰒓 System" -mesg "j/k · l/Enter · q close" -format i)

[[ -z "$choice_idx" ]] && exit 0

case "${actions[$choice_idx]}" in
    nightlight)       ~/.config/waybar/scripts/nightlight.sh toggle ;;
    caffeine)         ~/.config/waybar/scripts/caffeine.sh toggle ;;
    gamemode)         ~/.config/waybar/scripts/gamemode.sh toggle ;;
    screenrecord)     ~/.config/waybar/scripts/screenrecord.sh toggle ;;
    theme-picker)     ~/.config/theme/scripts/theme-picker.sh ;;
    wallpaper-picker) ~/.config/hypr/scripts/wallpaper/wallpaper-picker.sh ;;
    wallpaper-next)   echo "next" > /tmp/wallpaper-daemon.pipe ;;
    wallpaper-toggle) echo "toggle-pause" > /tmp/wallpaper-daemon.pipe ;;
    bright-up)        brightnessctl set 10%+ ;;
    bright-down)      brightnessctl set 10%- ;;
    screenshot)       ~/.config/waybar/scripts/screenshot.sh ;;
    colorpicker)      ~/.config/waybar/scripts/colorpicker.sh ;;
    keybinds)         ~/.config/hypr/scripts/system/keybind-hints.sh ;;
esac
