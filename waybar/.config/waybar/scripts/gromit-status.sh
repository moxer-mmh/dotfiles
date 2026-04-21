#!/usr/bin/env bash
# Waybar custom module — shows gromit draw-mode state.
# State contract:
#   /tmp/gromit-submap-state present → user is in the "draw" submap.
#     file contents = current composed tool name (e.g. "blue Rectangle").
#   file missing → module outputs empty text → waybar hides it.
#
# Deliberately keyed on submap-state (not canvas-state): when the user hits
# Escape to leave the submap but keeps the canvas visible to type around
# their annotations, the indicator should disappear — they are not in
# draw mode anymore, even though the strokes are still on screen.
#
# Refresh is signal-driven: enter/exit/tool/submap-leave scripts run
# `pkill -RTMIN+8 waybar` after changing the state, so this script only
# runs on session start + on those signals. No polling interval.

STATE=/tmp/gromit-submap-state

if [[ -f "$STATE" ]]; then
    tool=$(<"$STATE")
    tool="${tool:-Draw}"
    # JSON escape backslashes and double-quotes defensively.
    esc=${tool//\\/\\\\}
    esc=${esc//\"/\\\"}
    printf '{"text":"✏ %s","class":"active","tooltip":"Gromit draw mode\\nColors: R red  B blue  Y yellow  G green\\nShapes: P pen  L line  T rect  O circle  F filled  S smooth\\nE eraser  •  U undo  Shift+U redo  X clear  V hide\\nEsc leave submap  •  I exit draw mode"}\n' "$esc"
else
    printf '{"text":"","class":"inactive"}\n'
fi
