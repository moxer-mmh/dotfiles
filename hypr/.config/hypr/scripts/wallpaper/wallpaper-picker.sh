#!/bin/bash

# wallpaper-picker.sh
# Rofi thumbnail picker for the wallpaper daemon
# Generates 128x72 thumbnails via ImageMagick and presents them with icons

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"
PIPE="/tmp/wallpaper-daemon.pipe"
ROFI_THEME="$HOME/.config/rofi/space-station.rasi"

# ── Dependency check ──────────────────────────────────────────────────────────

for dep in rofi magick; do
    if ! command -v "$dep" &>/dev/null; then
        notify-send "wallpaper-picker" "Missing dependency: $dep" 2>/dev/null
        echo "ERROR: $dep not found in PATH" >&2
        exit 1
    fi
done

# ── Thumbnail cache ───────────────────────────────────────────────────────────

mkdir -p "$THUMB_DIR"

generate_thumbnail() {
    local src="$1"
    # Use a hash of the full path as the filename to avoid collisions
    local hash
    hash=$(printf '%s' "$src" | md5sum | cut -d' ' -f1)
    local thumb="$THUMB_DIR/${hash}.png"

    if [[ ! -f "$thumb" ]]; then
        magick "$src" -thumbnail 128x72^ -gravity center -extent 128x72 "$thumb" 2>/dev/null
    fi

    echo "$thumb"
}

# ── Build wallpaper list and rofi entries ─────────────────────────────────────

# Store full paths in an array for index-based lookup
mapfile -d '' WALLPAPERS < <(
    find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z
)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    notify-send "wallpaper-picker" "No wallpapers found in $WALLPAPER_DIR" 2>/dev/null
    exit 1
fi

build_entries() {
    for wallpaper in "${WALLPAPERS[@]}"; do
        local name thumb
        name=$(basename "$wallpaper")
        thumb=$(generate_thumbnail "$wallpaper")
        printf "%s\x00icon\x1f%s\n" "$name" "$thumb"
    done
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Use -format i to get the selected INDEX, avoiding name-matching issues
selected_idx=$(
    build_entries \
        | rofi \
            -dmenu \
            -p "Wallpaper" \
            -format i \
            -display-columns 1 \
            -show-icons \
            -theme "$ROFI_THEME" \
            -theme-str 'window { width: 800px; } listview { columns: 4; lines: 4; }'
)

[[ -z "$selected_idx" ]] && exit 0

full_path="${WALLPAPERS[$selected_idx]}"

if [[ -z "$full_path" || ! -f "$full_path" ]]; then
    notify-send "wallpaper-picker" "Invalid selection (index: $selected_idx)" 2>/dev/null
    exit 1
fi

if [[ ! -p "$PIPE" ]]; then
    notify-send "wallpaper-picker" "Daemon not running — pipe not found at $PIPE" 2>/dev/null
    exit 1
fi

echo "set $full_path" > "$PIPE"
