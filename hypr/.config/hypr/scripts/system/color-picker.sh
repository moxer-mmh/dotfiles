#!/bin/bash
# color-picker.sh — Pick a color from screen

if ! command -v hyprpicker &>/dev/null; then
    notify-send "Color Picker" "hyprpicker not installed" -u warning
    exit 1
fi

hyprpicker -a -n
sleep 0.3
color=$(wl-paste 2>/dev/null)

if [[ -n "$color" ]]; then
    notify-send "Color Picked" "$color" -t 2000
fi
