#!/usr/bin/env bash

PID_FILE="/tmp/screenrecord.pid"
RECORDINGS_DIR="$HOME/Videos/Recordings"

mkdir -p "$RECORDINGS_DIR"

is_recording() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            return 0
        else
            # Stale pidfile — clean it up
            rm -f "$PID_FILE"
            return 1
        fi
    fi
    return 1
}

cmd_toggle() {
    if is_recording; then
        local pid
        pid=$(cat "$PID_FILE")
        local output_file
        output_file=$(ls -t "$RECORDINGS_DIR"/screen-*.mp4 2>/dev/null | head -n1)

        kill -SIGINT "$pid"
        # Wait briefly for the process to exit and finalize the file
        sleep 1
        rm -f "$PID_FILE"

        if [[ -n "$output_file" ]]; then
            notify-send -i media-record "Screen Recorder" "Recording saved to $output_file" -t 5000
        else
            notify-send -i media-record "Screen Recorder" "Recording stopped." -t 3000
        fi
    else
        local timestamp
        timestamp=$(date +%Y%m%d-%H%M%S)
        local output_file="$RECORDINGS_DIR/screen-${timestamp}.mp4"

        wf-recorder -f "$output_file" &
        local pid=$!
        echo "$pid" > "$PID_FILE"

        notify-send -i media-record "Screen Recorder" "Recording started" -t 3000
    fi
}

cmd_status() {
    if is_recording; then
        printf '{"text": "󰑋", "class": "recording", "tooltip": "Recording in progress"}\n'
    else
        printf '{"text": "󰑊", "class": "idle", "tooltip": "Screen Recorder: Idle"}\n'
    fi
}

case "$1" in
    toggle) cmd_toggle ;;
    status) cmd_status ;;
    *)
        echo "Usage: $0 {toggle|status}" >&2
        exit 1
        ;;
esac
