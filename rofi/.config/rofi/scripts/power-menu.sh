#!/bin/bash

# Rofi Power Menu Script
# Save as ~/.config/rofi/scripts/power-menu.sh

# Options
shutdown="⏻ Shutdown"
reboot="↻ Restart"
lock="🔒 Lock"
logout="⏻ Logout"
suspend="⏸ Suspend"
hibernate="⏹ Hibernate"

# Variable passed to rofi
options="$lock\n$logout\n$suspend\n$hibernate\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | rofi -dmenu -p "Power Menu" -theme ~/.config/rofi/cyberpunk.rasi)"

case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        swaylock
        ;;
    $logout)
        hyprctl dispatch exit
        ;;
    $suspend)
        systemctl suspend
        ;;
    $hibernate)
        systemctl hibernate
        ;;
esac
