#!/usr/bin/env bash

hyprpicker -a -n

# Give the clipboard a moment to populate
sleep 0.3

picked=$(wl-paste 2>/dev/null)

if [[ -n "$picked" ]]; then
    notify-send "Color Picked" "$picked" -t 2000
fi
