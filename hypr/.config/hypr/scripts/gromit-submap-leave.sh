#!/usr/bin/env bash
# Leave the "draw" submap but keep the gromit canvas visible.
# Bound to Escape inside the submap — lets the user type in other apps
# while annotations stay on screen.
#
# Only clears SUBMAP_STATE (hides waybar indicator) — CANVAS_STATE is
# deliberately untouched so the next Super+I won't double-toggle.

set -euo pipefail

SUBMAP_STATE=/tmp/gromit-submap-state

hyprctl dispatch submap reset >/dev/null 2>&1 || true
rm -f "$SUBMAP_STATE"
pkill -RTMIN+8 waybar 2>/dev/null || true
