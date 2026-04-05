#!/usr/bin/env bash

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"

OPTION_WINDOW="󰖲 Active Window"
OPTION_REGION="󰆞 Select Region"
OPTION_FULLSCREEN="󰍹 Full Screen"
OPTION_DELAYED="󰔝 Delayed (3s)"

choice=$(printf '%s\n' \
    "$OPTION_WINDOW" \
    "$OPTION_REGION" \
    "$OPTION_FULLSCREEN" \
    "$OPTION_DELAYED" \
    | rofi -dmenu \
           -p "Screenshot" \
           -theme-str 'window {width: 400px;}' \
           -no-fixed-num-lines)

[[ -z "$choice" ]] && exit 0

case "$choice" in
    "$OPTION_WINDOW")
        hyprshot -m window -o "$SCREENSHOTS_DIR"
        ;;
    "$OPTION_REGION")
        hyprshot -m region -o "$SCREENSHOTS_DIR"
        ;;
    "$OPTION_FULLSCREEN")
        hyprshot -m output -o "$SCREENSHOTS_DIR"
        ;;
    "$OPTION_DELAYED")
        sleep 3 && hyprshot -m region -o "$SCREENSHOTS_DIR"
        ;;
    *)
        exit 1
        ;;
esac
