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

# ── Build rofi entries ────────────────────────────────────────────────────────

build_entries() {
    while IFS= read -r -d '' wallpaper; do
        local name thumb
        name=$(basename "$wallpaper")
        thumb=$(generate_thumbnail "$wallpaper")

        # Rofi icon mode: "display_text\x00icon\x1fpath_to_icon"
        printf "%s\x00icon\x1f%s\n" "$name" "$thumb"
    done < <(
        find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z
    )
}

# ── Resolve selection back to full path ───────────────────────────────────────

resolve_path() {
    local name="$1"
    find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
        | awk -F'/' -v n="$name" '{ if ($NF == n) print }' \
        | head -1
}

# ── Main ──────────────────────────────────────────────────────────────────────

entries=$(build_entries)

if [[ -z "$entries" ]]; then
    notify-send "wallpaper-picker" "No wallpapers found in $WALLPAPER_DIR" 2>/dev/null
    exit 1
fi

selected=$(
    printf '%s' "$entries" \
        | rofi \
            -dmenu \
            -p "Wallpaper" \
            -display-columns 1 \
            -show-icons \
            -theme "$ROFI_THEME" \
            -theme-str 'window { width: 800px; } listview { columns: 4; lines: 4; }'
)

[[ -z "$selected" ]] && exit 0

full_path=$(resolve_path "$selected")

if [[ -z "$full_path" ]]; then
    notify-send "wallpaper-picker" "Could not resolve path for: $selected" 2>/dev/null
    exit 1
fi

if [[ ! -p "$PIPE" ]]; then
    notify-send "wallpaper-picker" "Daemon not running — pipe not found at $PIPE" 2>/dev/null
    exit 1
fi

echo "set $full_path" > "$PIPE"
