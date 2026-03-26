#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"
INTERVAL=30

set_wallpaper() {
    local wallpaper="$1"

    ln -sf "$wallpaper" "$CURRENT_WALLPAPER"

    awww img "$wallpaper" --transition-type fade --transition-duration 2

    pkill -USR2 hyprlock 2>/dev/null
}

cycle_wallpapers() {
    mapfile -t wallpapers < <(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf)

    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "❌ No wallpapers found in $WALLPAPER_DIR"
        echo "📁 Please add .jpg, .jpeg, or .png files to the wallpaper directory"
        return 1
    fi

    echo "🌌 Starting cosmic wallpaper cycle with ${#wallpapers[@]} wallpapers"
    echo "⏱️  Interval: ${INTERVAL} seconds per wallpaper"
    echo "📂 Source: $WALLPAPER_DIR"

    while true; do
        for wallpaper in "${wallpapers[@]}"; do
            echo "🖼️  Setting wallpaper: $(basename "$wallpaper")"
            set_wallpaper "$wallpaper"

            sleep "$INTERVAL"
        done

        echo "🔄 Reshuffling wallpaper order for next cycle..."
        mapfile -t wallpapers < <(printf '%s\n' "${wallpapers[@]}" | shuf)
    done
}

echo "🚀 Initializing Space Station Wallpaper System..."
echo "📡 Checking dependencies and configuration..."

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "❌ Error: Wallpaper directory does not exist: $WALLPAPER_DIR"
    echo "📁 Please create the directory and add wallpaper images"
    exit 1
fi

if ! command -v awww >/dev/null 2>&1; then
    echo "❌ Error: AWWW wallpaper daemon not found"
    echo "📦 Please install AWWW: sudo pacman -S awww"
    exit 1
fi

cycle_wallpapers
