#!/bin/bash
# theme-picker.sh — Rofi-based theme selector

THEMES_DIR="$HOME/.config/theme/colors/themes"
APPLY_SCRIPT="$HOME/.config/theme/scripts/apply-theme.sh"

# Build menu entries
entries=""
for theme_file in "$THEMES_DIR"/*.conf; do
    name=$(basename "$theme_file" .conf)
    # Read first color for a visual hint
    primary=$(grep "COLOR_PRIMARY=" "$theme_file" | head -1 | cut -d'"' -f2)
    entries+="$name\n"
done
entries+="wallpaper"

# Show rofi picker
selected=$(echo -e "$entries" | rofi -dmenu \
    -theme ~/.config/rofi/space-station.rasi \
    -p "  Theme" \
    -mesg "Select a theme or 'wallpaper' for auto-colors")

if [[ -n "$selected" ]]; then
    "$APPLY_SCRIPT" "$selected"
fi
