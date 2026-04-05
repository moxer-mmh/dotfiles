#!/bin/bash
# power-menu.sh — Launch wlogout power menu
# Part of the Hyprland Space Station setup

if ! command -v wlogout &>/dev/null; then
    notify-send -u critical "Power Menu" "wlogout is not installed. Install it to use the power menu."
    exit 1
fi

wlogout -b 5 -c 0 -r 0.5 -L 600 -R 600 -T 300 -B 300
