#!/usr/bin/env bash
# Gromit-MPX tool selector — Paint-style composable shape + color.
#
# Usage:
#   gromit-tool.sh shape <ShapeName>   # e.g. shape Rectangle
#   gromit-tool.sh color <ColorName>   # e.g. color blue
#   gromit-tool.sh eraser              # special: no color/shape
#
# State files (survive across submap re-entries, cleared only on reboot):
#   /tmp/gromit-shape   current shape (default: Pen)
#   /tmp/gromit-color   current color (default: red)
#
# The composed tool name is "${color} ${shape}" — which MUST exist as a
# definition in ~/.config/gromit-mpx.cfg. See that file for the full 4×6
# Cartesian grid of shape×color tools.
#
# `eraser` is a special case: it writes "Eraser" to the cfg directly, but
# deliberately does NOT touch the shape/color state — pressing R/B/Y/G or a
# shape key next will exit eraser mode cleanly into the preserved combo.

set -euo pipefail

CFG="$HOME/.config/gromit-mpx.cfg"
SHAPE_STATE=/tmp/gromit-shape
COLOR_STATE=/tmp/gromit-color
SUBMAP_STATE=/tmp/gromit-submap-state
CANVAS_STATE=/tmp/gromit-canvas-state

MODE="${1:?Usage: gromit-tool.sh (shape|color|eraser) [VALUE]}"

[[ -f "$CFG" ]] || exit 1
grep -qE '^"default"[[:space:]]+=' "$CFG" || exit 1

case "$MODE" in
    shape)
        SHAPE="${2:?Usage: gromit-tool.sh shape <ShapeName>}"
        printf '%s' "$SHAPE" > "$SHAPE_STATE"
        COLOR=$(cat "$COLOR_STATE" 2>/dev/null || echo red)
        TOOL="$COLOR $SHAPE"
        ;;
    color)
        COLOR="${2:?Usage: gromit-tool.sh color <ColorName>}"
        printf '%s' "$COLOR" > "$COLOR_STATE"
        SHAPE=$(cat "$SHAPE_STATE" 2>/dev/null || echo Pen)
        TOOL="$COLOR $SHAPE"
        ;;
    eraser)
        TOOL="Eraser"
        ;;
    *)
        echo "Unknown mode: $MODE" >&2
        exit 1
        ;;
esac

# Escape regex metacharacters in the tool name for the sed replacement.
ESCAPED_TOOL=$(printf '%s' "$TOOL" | sed 's/[\/&]/\\&/g')
sed -i -E "s|^\"default\"([[:space:]]+)=([[:space:]]+)\"[^\"]+\";|\"default\"\\1=\\2\"${ESCAPED_TOOL}\";|" "$CFG"

# Bail early if the daemon is dead — otherwise we'd silently rewrite the cfg
# with nothing to pick it up, and leave the user stuck in the submap.
if ! pgrep -f "/usr/local/bin/gromit-mpx" >/dev/null 2>&1; then
    hyprctl dispatch submap reset >/dev/null 2>&1 || true
    rm -f "$SUBMAP_STATE" "$CANVAS_STATE"
    pkill -RTMIN+8 waybar 2>/dev/null || true
    exit 1
fi

env GDK_BACKEND=x11 /usr/local/bin/gromit-mpx --reload >/dev/null 2>&1 || true

# Push the composed tool name into the waybar indicator.
printf '%s' "$TOOL" > "$SUBMAP_STATE"
pkill -RTMIN+8 waybar 2>/dev/null || true
