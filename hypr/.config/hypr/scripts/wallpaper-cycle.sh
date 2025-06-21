#!/bin/bash
# 🚀 Space Station Wallpaper Cycling Script

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"
INTERVAL=30  # seconds

set_wallpaper() {
    local wallpaper="$1"

    # Update symlink
    ln -sf "$wallpaper" "$CURRENT_WALLPAPER"

    # Apply wallpaper with SWWW
    swww img "$wallpaper" --transition-type fade --transition-duration 2

    # Trigger hyprlock to reload (if running)
    pkill -USR2 hyprlock 2>/dev/null
}

cycle_wallpapers() {
    mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf)

    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi

    echo "🌌 Starting cosmic wallpaper cycle with ${#wallpapers[@]} wallpapers"

    while true; do
        for wallpaper in "${wallpapers[@]}"; do
            echo "🖼️  Setting wallpaper: $(basename "$wallpaper")"
            set_wallpaper "$wallpaper"
            sleep "$INTERVAL"
        done
        mapfile -t wallpapers < <(printf '%s\n' "${wallpapers[@]}" | shuf)
    done
}

# Start cycling
cycle_wallpapers

