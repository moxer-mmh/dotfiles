#!/bin/bash
# 📷 Camera Toggle Script for MSI Laptops
# Handles F6 camera key and provides status feedback

CAMERA_STATE_FILE="/tmp/.camera_state"

# Function to detect camera hardware state
get_camera_hardware_state() {
    # Method 1: Try to access camera with timeout
    if timeout 1 ffmpeg -f v4l2 -i /dev/video0 -frames:v 1 -f null - >/dev/null 2>&1; then
        echo "available"
        return 0
    fi
    
    # Method 2: Check if camera device exists and is accessible
    if [[ -e "/dev/video0" ]]; then
        if v4l2-ctl --device=/dev/video0 --list-formats >/dev/null 2>&1; then
            echo "available"
            return 0
        fi
    fi
    
    # Method 3: Check USB camera presence
    if lsusb | grep -i "camera\|webcam" >/dev/null; then
        # Camera USB device exists but might be disabled
        echo "blocked"
        return 1
    fi
    
    echo "unknown"
    return 2
}

# Function to toggle camera state file (for tracking F6 presses)
toggle_camera_state() {
    if [[ -f "$CAMERA_STATE_FILE" ]]; then
        local current_state=$(cat "$CAMERA_STATE_FILE")
        if [[ "$current_state" == "enabled" ]]; then
            echo "disabled" > "$CAMERA_STATE_FILE"
            notify-send "📷 Camera" "Camera disabled via F6 key" -t 3000
        else
            echo "enabled" > "$CAMERA_STATE_FILE"
            notify-send "📷 Camera" "Camera enabled via F6 key" -t 3000
        fi
    else
        # Initialize state file
        echo "enabled" > "$CAMERA_STATE_FILE"
        notify-send "📷 Camera" "Camera state tracking initialized" -t 3000
    fi
}

# Function to check current camera state
check_camera_state() {
    local hw_state=$(get_camera_hardware_state)
    local sw_state="unknown"
    
    if [[ -f "$CAMERA_STATE_FILE" ]]; then
        sw_state=$(cat "$CAMERA_STATE_FILE")
    fi
    
    echo "Hardware: $hw_state, Software: $sw_state"
}

case "$1" in
    "toggle")
        toggle_camera_state
        ;;
    "check")
        check_camera_state
        ;;
    "hardware")
        get_camera_hardware_state
        ;;
    *)
        # Default action when F6 is pressed
        toggle_camera_state
        ;;
esac
