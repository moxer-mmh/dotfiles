#!/usr/bin/env bash
# Full exit from gromit-mpx draw mode — idempotent.
# Turns canvas off, leaves the submap, clears both state files.
#
# Only --toggle the canvas if CANVAS_STATE says it's currently on.
# Always reset the submap so the user is never trapped.

set -euo pipefail

GROMIT=/usr/local/bin/gromit-mpx
CANVAS_STATE=/tmp/gromit-canvas-state
SUBMAP_STATE=/tmp/gromit-submap-state

if [[ -f "$CANVAS_STATE" ]] && pgrep -f "$GROMIT" >/dev/null 2>&1; then
    env GDK_BACKEND=x11 "$GROMIT" --toggle >/dev/null 2>&1 || true
fi

hyprctl dispatch submap reset >/dev/null 2>&1 || true

rm -f "$CANVAS_STATE" "$SUBMAP_STATE"
pkill -RTMIN+8 waybar 2>/dev/null || true
