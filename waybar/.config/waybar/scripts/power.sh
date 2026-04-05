#!/bin/bash
# Kill existing wlogout if running, then launch
pkill wlogout 2>/dev/null; sleep 0.1
exec wlogout \
    --layout ~/.config/wlogout/layout \
    --css ~/.config/wlogout/style.css \
    -b 3 -c 0 -r 0.5 \
    -L 500 -R 500 -T 250 -B 250
