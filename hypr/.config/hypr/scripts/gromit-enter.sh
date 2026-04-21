#!/usr/bin/env bash
# Enter gromit-mpx draw mode — idempotent.
#
# State contract (4 files):
#   /tmp/gromit-canvas-state  exists ⇔ gromit canvas is VISIBLE
#   /tmp/gromit-submap-state  exists ⇔ user is in the "draw" submap
#                              contents = current composed tool name
#   /tmp/gromit-shape         current shape (Pen / Rectangle / ...)
#   /tmp/gromit-color         current color (red / blue / yellow / green)
#
# On entry we (a) ensure the daemon is alive, (b) toggle the canvas on iff
# canvas-state says it's currently off, (c) initialize shape/color defaults
# if this is the first session since reboot, (d) compose "{color} {shape}"
# and sync gromit's cfg to match — so the shape/color state is the source of
# truth, even if the cfg got out of sync externally.
#
# No notifications — the waybar module owns all visible state.

set -euo pipefail

GROMIT=/usr/local/bin/gromit-mpx
CFG="$HOME/.config/gromit-mpx.cfg"
CANVAS_STATE=/tmp/gromit-canvas-state
SHAPE_STATE=/tmp/gromit-shape
COLOR_STATE=/tmp/gromit-color
SUBMAP_STATE=/tmp/gromit-submap-state

if ! pgrep -f "$GROMIT" >/dev/null 2>&1; then
    env GDK_BACKEND=x11 DISPLAY=:0 "$GROMIT" >/dev/null 2>&1 &
    disown
    sleep 0.4
    # Fresh daemon starts with canvas hidden → state must match.
    rm -f "$CANVAS_STATE"
fi

# Only --toggle if canvas is currently off. Double-toggles are the #1 source
# of confusion in this flow.
if [[ ! -f "$CANVAS_STATE" ]]; then
    env GDK_BACKEND=x11 "$GROMIT" --toggle >/dev/null 2>&1 || true
    : > "$CANVAS_STATE"
fi

hyprctl dispatch submap draw >/dev/null 2>&1 || true

# Initialize shape/color state on first entry (or after /tmp clears on reboot).
[[ -f "$SHAPE_STATE" ]] || printf 'Pen' > "$SHAPE_STATE"
[[ -f "$COLOR_STATE" ]] || printf 'red' > "$COLOR_STATE"

color=$(cat "$COLOR_STATE")
shape=$(cat "$SHAPE_STATE")
tool="$color $shape"

# Force gromit's cfg to match the composed tool, then --reload so the daemon
# picks up whatever was in state before this enter call.
ESCAPED_TOOL=$(printf '%s' "$tool" | sed 's/[\/&]/\\&/g')
sed -i -E "s|^\"default\"([[:space:]]+)=([[:space:]]+)\"[^\"]+\";|\"default\"\\1=\\2\"${ESCAPED_TOOL}\";|" "$CFG"
env GDK_BACKEND=x11 "$GROMIT" --reload >/dev/null 2>&1 || true

printf '%s' "$tool" > "$SUBMAP_STATE"
pkill -RTMIN+8 waybar 2>/dev/null || true
