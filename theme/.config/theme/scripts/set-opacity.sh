#!/bin/bash
# set-opacity — Change terminal/window opacity and persist it
# Usage: set-opacity 0.95

set -euo pipefail

OVERRIDES="$HOME/.config/theme/colors/user-overrides.conf"
OPACITY="${1:-}"

if [[ -z "$OPACITY" ]]; then
    # Show current value
    current=$(grep '^COLOR_BG_ALPHA=' "$OVERRIDES" 2>/dev/null | cut -d'"' -f2)
    echo "Current opacity: ${current:-not set}"
    echo "Usage: set-opacity <0.0-1.0>"
    exit 0
fi

# Validate format, then range. The format check matters: the value is inlined
# into a Lua snippet for hyprctl eval below.
if ! [[ "$OPACITY" =~ ^[0-9]*\.?[0-9]+$ ]]; then
    echo "Error: opacity must be a number between 0.0 and 1.0"
    exit 1
fi
if ! awk "BEGIN{exit !($OPACITY >= 0.0 && $OPACITY <= 1.0)}" 2>/dev/null; then
    echo "Error: opacity must be between 0.0 and 1.0"
    exit 1
fi

# Update or create the overrides file
if [[ -f "$OVERRIDES" ]] && grep -q '^COLOR_BG_ALPHA=' "$OVERRIDES"; then
    sed -i "s|^COLOR_BG_ALPHA=.*|COLOR_BG_ALPHA=\"$OPACITY\"|" "$OVERRIDES"
else
    mkdir -p "$(dirname "$OVERRIDES")"
    echo "COLOR_BG_ALPHA=\"$OPACITY\"" >> "$OVERRIDES"
fi

# Live-apply: kitty opacity
if pgrep kitty &>/dev/null; then
    kitty @ --to unix:/tmp/kitty-sock set-background-opacity "$OPACITY" 2>/dev/null || true
fi

# Live-apply: hyprland active opacity
# (hyprctl keyword is gone since Hyprland 0.57; options are set through Lua.
# $OPACITY is already validated as a number above, so it is safe to inline.)
hyprctl eval "hl.config({ decoration = { active_opacity = $OPACITY } })" >/dev/null 2>&1 || true

echo "Opacity set to $OPACITY (persisted in user-overrides.conf)"
