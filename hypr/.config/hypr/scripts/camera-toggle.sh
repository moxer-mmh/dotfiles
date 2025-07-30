#!/bin/bash
CAMERA_STATE_FILE="/tmp/.camera_state"

get_camera_hardware_state() {
    if timeout 1 ffmpeg -f v4l2 -i /dev/video0 -frames:v 1 -f null - >/dev/null 2>&1; then
        echo "available"
        return 0
    fi

    if [[ -e "/dev/video0" ]]; then
        if v4l2-ctl --device=/dev/video0 --list-formats >/dev/null 2>&1; then
            echo "available"
            return 0
        fi
    fi

    if lsusb | grep -i "camera\|webcam" >/dev/null; then
        echo "blocked"
        return 1
    fi

    echo "unknown"
    return 2
}

toggle_camera_state() {
    if [[ -f "$CAMERA_STATE_FILE" ]]; then
        local current_state=$(cat "$CAMERA_STATE_FILE")

        if [[ "$current_state" == "enabled" ]]; then
            echo "disabled" > "$CAMERA_STATE_FILE"
            notify-send "📷 Camera" "Camera disabled via F6 key" \
                -t 3000 \
                -u normal \
                -i camera-disabled
        else
            echo "enabled" > "$CAMERA_STATE_FILE"
            notify-send "📷 Camera" "Camera enabled via F6 key" \
                -t 3000 \
                -u normal \
                -i camera-enabled
        fi
    else
        echo "enabled" > "$CAMERA_STATE_FILE"
        notify-send "📷 Camera" "Camera state tracking initialized" \
            -t 3000 \
            -u low \
            -i camera-ready
    fi
}

check_camera_state() {
    local hw_state=$(get_camera_hardware_state)
    local sw_state="unknown"

    if [[ -f "$CAMERA_STATE_FILE" ]]; then
        sw_state=$(cat "$CAMERA_STATE_FILE")
    else
        sw_state="uninitialized"
    fi

    echo "🔍 Camera Status Report:"
    echo "  Hardware State: $hw_state"
    echo "  Software State: $sw_state"
    echo "  State File: $CAMERA_STATE_FILE"

    case "$hw_state" in
        "available")
            echo "  ✅ Camera is functional and accessible"
            ;;
        "blocked")
            echo "  🚫 Camera hardware detected but blocked (F6 switch?)"
            ;;
        "unknown")
            echo "  ❓ Camera state cannot be determined"
            ;;
    esac
}

case "$1" in
    "toggle")
        echo "🔄 Toggling camera state..."
        toggle_camera_state
        ;;
    "check")
        check_camera_state
        ;;
    "hardware")
        echo "🔍 Checking hardware state..."
        hw_state=$(get_camera_hardware_state)
        echo "Camera hardware: $hw_state"
        ;;
    "help"|"--help"|"-h")
        echo "📷 Space Station Camera Control System"
        echo ""
        echo "Usage:"
        echo "  $0                - Toggle camera state (default)"
        echo "  $0 toggle         - Explicitly toggle camera state"
        echo "  $0 check          - Display current camera status"
        echo "  $0 hardware       - Check hardware availability only"
        echo "  $0 help           - Show this help message"
        echo ""
        echo "State file: $CAMERA_STATE_FILE"
        ;;
    *)
        echo "📷 F6 key pressed - toggling camera state..."
        toggle_camera_state
        ;;
esac
