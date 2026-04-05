#!/bin/bash
# screen-record.sh — Screen recording via wf-recorder

PIDFILE="/tmp/screenrecord.pid"
OUTDIR="$HOME/Videos/Recordings"

mkdir -p "$OUTDIR"

is_recording() {
    [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null
}

start_recording() {
    local mode="$1"
    local outfile="$OUTDIR/screen-$(date +%Y%m%d-%H%M%S).mp4"

    case "$mode" in
        region)
            local geometry
            geometry=$(slurp 2>/dev/null)
            [[ -z "$geometry" ]] && exit 0
            wf-recorder -g "$geometry" -f "$outfile" &
            ;;
        window)
            local geometry
            geometry=$(hyprctl activewindow -j | python3 -c "import sys,json;w=json.load(sys.stdin);print(f\"{w['at'][0]},{w['at'][1]} {w['size'][0]}x{w['size'][1]}\")" 2>/dev/null)
            [[ -z "$geometry" ]] && { wf-recorder -f "$outfile" & ; }
            wf-recorder -g "$geometry" -f "$outfile" &
            ;;
        *)
            wf-recorder -f "$outfile" &
            ;;
    esac

    echo $! > "$PIDFILE"
    notify-send "Recording Started" "Saving to $(basename "$outfile")" -t 2000
}

stop_recording() {
    if is_recording; then
        kill -INT "$(cat "$PIDFILE")" 2>/dev/null
        sleep 1
        rm -f "$PIDFILE"
        local latest
        latest=$(ls -t "$OUTDIR"/screen-*.mp4 2>/dev/null | head -1)
        if [[ -n "$latest" ]]; then
            notify-send "Recording Saved" "$(basename "$latest")" -t 3000
        fi
    fi
}

case "${1:-menu}" in
    toggle)
        if is_recording; then
            stop_recording
        else
            start_recording full
        fi
        ;;
    menu)
        if is_recording; then
            stop_recording
        else
            choice=$(printf "󰍹 Full Screen\n󰆞 Select Region\n󰖲 Active Window" | \
                rofi -dmenu -theme ~/.config/rofi/space-station.rasi -p "  Record")
            case "$choice" in
                *"Full Screen") start_recording full ;;
                *"Select Region") start_recording region ;;
                *"Active Window") start_recording window ;;
            esac
        fi
        ;;
    status)
        if is_recording; then
            printf '{"text": "󰑋", "class": "recording", "tooltip": "Recording in progress"}\n'
        else
            printf '{"text": "󰑊", "class": "idle", "tooltip": "Screen recorder"}\n'
        fi
        ;;
esac
