#!/bin/bash

#═══════════════════════════════════════════════════════════════════════════════
# 📷 CAMERA STATUS MONITOR FOR WAYBAR
#═══════════════════════════════════════════════════════════════════════════════
#
# A comprehensive camera status monitoring script for Waybar that provides
# real-time camera availability, usage, and hardware state detection with
# cosmic-themed visual indicators and detailed tooltip information.
#
# FEATURES:
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ • Real-time camera device detection and status monitoring                  │
# │ • F6 function key state tracking for hardware toggle support               │
# │ • USB camera hardware presence detection via lsusb                         │
# │ • Active usage detection through file descriptor monitoring                │
# │ • Kernel module status checking (uvcvideo, gspca, pwc)                     │
# │ • Color-coded status indicators with cosmic theme integration              │
# │ • Detailed tooltip with device information and process tracking            │
# │ • Cross-platform compatibility with v4l2 and standard Linux tools          │
# └─────────────────────────────────────────────────────────────────────────────┘
#
# STATUS INDICATORS:
# • 🟢 Green (󰄀): Camera available and ready for use
# • 🟡 Yellow (󰄁): Camera actively recording/in use
# • 🔴 Red (󰖠): Camera disabled or hardware unavailable
# • ⚫ Gray (󰄀): Unknown state or no modules loaded
#
# DEPENDENCIES:
# - lsof: Process and file descriptor monitoring
# - v4l2-ctl: Video4Linux2 device control and information
# - lsusb: USB device enumeration
# - lsmod: Kernel module status checking
# - find: Device file discovery
#
# INTEGRATION:
# Add to waybar config.jsonc:
# "custom/camera": {
#     "format": "{}",
#     "exec": "~/.config/waybar/scripts/camera.sh status",
#     "interval": 3,
#     "tooltip": true,
#     "tooltip-format": "{}",
#     "exec-tooltip": "~/.config/waybar/scripts/camera.sh tooltip",
#     "on-click": "~/.config/hypr/scripts/camera-toggle.sh"
# }
#
# AUTHOR: Space Station Development Environment
# VERSION: 1.0.0
# LAST UPDATED: June 2025
#
#═══════════════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────────────
# CAMERA STATUS DETECTION FUNCTION
# Performs comprehensive camera availability and usage analysis
#───────────────────────────────────────────────────────────────────────────────

get_camera_status() {
    # Initialize status variables for comprehensive camera state tracking
    local output=""                  # Final formatted output for Waybar
    local camera_available=0         # Camera accessible and ready (0=false, 1=true)
    local camera_blocked=0           # Camera hardware blocked/disabled
    local camera_in_use=0            # Camera actively being used by processes
    local f6_state="unknown"         # F6 function key toggle state
    
    #───────────────────────────────────────────────────────────────────────────
    # F6 HARDWARE TOGGLE STATE DETECTION
    # Check if user has manually disabled camera via F6 function key
    #───────────────────────────────────────────────────────────────────────────
    
    if [[ -f "/tmp/.camera_state" ]]; then
        f6_state=$(cat "/tmp/.camera_state")  # Read cached F6 state
    fi
    
    #───────────────────────────────────────────────────────────────────────────
    # VIDEO DEVICE ENUMERATION AND ACCESSIBILITY TESTING
    # Discover all video devices and test their accessibility/usage status
    #───────────────────────────────────────────────────────────────────────────
    
    # Find all video devices in /dev (video0, video1, etc.)
    local video_devices=($(find /dev -name "video*" 2>/dev/null))
    
    if [[ ${#video_devices[@]} -gt 0 ]]; then
        # Video devices found - check if any are currently in use
        local video_in_use=0
        
        for device in "${video_devices[@]}"; do
            # Use lsof to check if any process has the device open
            if lsof "$device" 2>/dev/null | grep -q "$device"; then
                video_in_use=1       # Device is actively being used
                break
            fi
        done
        
        if [[ "$video_in_use" -eq 1 ]]; then
            # Camera is actively recording/streaming
            camera_in_use=1
            camera_available=1
        else
            # Devices exist but not in use - test accessibility
            for device in "${video_devices[@]}"; do
                # Test device readability and v4l2 compatibility with timeout
                if [[ -r "$device" ]] && timeout 0.2 v4l2-ctl --device="$device" --list-formats >/dev/null 2>&1; then
                    camera_available=1   # Device is accessible and functional
                    break
                fi
            done
        fi
    else
        # No video devices found - camera likely disabled or no hardware
        camera_blocked=1
    fi
    
    #───────────────────────────────────────────────────────────────────────────
    # USB CAMERA HARDWARE DETECTION
    # Check for camera hardware presence at USB level
    #───────────────────────────────────────────────────────────────────────────
    
    local usb_camera_present=0
    # Search for camera/webcam keywords in USB device listings
    if lsusb 2>/dev/null | grep -i "camera\|webcam" >/dev/null; then
        usb_camera_present=1         # USB camera hardware detected
    fi
    
    #───────────────────────────────────────────────────────────────────────────
    # KERNEL MODULE STATUS VERIFICATION
    # Check if camera-related kernel drivers are loaded
    #───────────────────────────────────────────────────────────────────────────
    
    local camera_modules_loaded=0
    # Check for common camera kernel modules (UVC, GSPCA, PWC drivers)
    if lsmod | grep -E "uvcvideo|gspca|pwc" >/dev/null 2>&1; then
        camera_modules_loaded=1      # Camera drivers are loaded
    fi
    
    #───────────────────────────────────────────────────────────────────────────
    # STATUS DETERMINATION AND VISUAL INDICATOR SELECTION
    # Apply logic hierarchy to determine final camera state and cosmic styling
    #───────────────────────────────────────────────────────────────────────────
    
    if [[ "$f6_state" == "disabled" ]]; then
        # Priority 1: F6 key explicitly disabled camera
        output="<span color='#FF4500'>󰖠</span>"  # 🔴 Red camera disabled icon
        
    elif [[ ${#video_devices[@]} -eq 0 && "$usb_camera_present" -eq 0 ]]; then
        # Priority 2: No camera hardware detected at all
        output="<span color='#FF4500'>󰖠</span>"  # 🔴 Red camera disabled icon
        
    elif [[ ${#video_devices[@]} -eq 0 && "$usb_camera_present" -eq 1 ]]; then
        # Priority 3: USB camera present but video devices unavailable (F6 disabled)
        output="<span color='#FF4500'>󰖠</span>"  # 🔴 Red camera disabled icon
        
    elif [[ "$camera_in_use" -eq 1 ]]; then
        # Priority 4: Camera is actively being used (recording/streaming)
        output="<span color='#FFD700'>󰄁</span>"  # 🟡 Yellow camera recording icon
        
    elif [[ "$camera_available" -eq 1 ]]; then
        # Priority 5: Camera is available and ready for use
        output="<span color='#00FF7F'>󰄀</span>"  # 🟢 Green camera available icon
        
    else
        # Fallback: Unknown state - use module status for best guess
        if [[ "$camera_modules_loaded" -eq 1 ]]; then
            output="<span color='#00FF7F'>󰄀</span>"  # 🟢 Green camera available icon
        else
            output="<span color='#666666'>󰄀</span>"  # ⚫ Gray camera unknown icon
        fi
    fi
    
    # Return formatted output for Waybar display
    echo "$output"
}

#───────────────────────────────────────────────────────────────────────────────
# CAMERA TOOLTIP INFORMATION FUNCTION
# Generates detailed camera status information for Waybar tooltip display
#───────────────────────────────────────────────────────────────────────────────

show_camera_tooltip() {
    local tooltip="Camera Status:\\n"
    local f6_state="Not tracked"    # Default F6 state if no file exists
    
    #───────────────────────────────────────────────────────────────────────────
    # F6 FUNCTION KEY STATE REPORTING
    # Display current hardware toggle status from cached state file
    #───────────────────────────────────────────────────────────────────────────
    
    if [[ -f "/tmp/.camera_state" ]]; then
        f6_state=$(cat "/tmp/.camera_state")  # Read cached F6 toggle state
    fi
    
    #───────────────────────────────────────────────────────────────────────────
    # SYSTEM HARDWARE INVENTORY
    # Gather comprehensive camera hardware and driver information
    #───────────────────────────────────────────────────────────────────────────
    
    # Count video devices in /dev
    local video_devices=($(find /dev -name "video*" 2>/dev/null))
    local devices_count=${#video_devices[@]}
    
    # Count USB camera devices
    local usb_cameras=$(lsusb 2>/dev/null | grep -i "camera\|webcam" | wc -l)
    
    # Count loaded camera kernel modules
    local modules_loaded=$(lsmod | grep -E "uvcvideo|gspca|pwc" | wc -l)
    
    #───────────────────────────────────────────────────────────────────────────
    # TOOLTIP HEADER INFORMATION
    # Display summary statistics and system state overview
    #───────────────────────────────────────────────────────────────────────────
    
    tooltip+="F6 Key State: $f6_state\\n"
    tooltip+="Video Devices: $devices_count found\\n"
    tooltip+="USB Cameras: $usb_cameras detected\\n"
    tooltip+="Camera Modules: $modules_loaded loaded\\n\\n"
    
    #───────────────────────────────────────────────────────────────────────────
    # DETAILED DEVICE INFORMATION
    # Enumerate each video device with name, status, and usage information
    #───────────────────────────────────────────────────────────────────────────
    
    if [[ $devices_count -gt 0 ]]; then
        tooltip+="Available Devices:\\n"
        
        for device in "${video_devices[@]}"; do
            # Extract device name using v4l2-ctl card information
            local device_name=$(v4l2-ctl --device="$device" --info 2>/dev/null | grep "Card type" | cut -d: -f2 | xargs)
            
            if [[ -n "$device_name" ]]; then
                tooltip+="$device: $device_name\\n"     # Named device
            else
                tooltip+="$device: Video Device\\n"     # Generic fallback name
            fi
            
            # Check active usage and report using processes
            if lsof "$device" 2>/dev/null | grep -q "$device"; then
                # Extract process names using the device
                local processes=$(lsof "$device" 2>/dev/null | grep "$device" | awk '{print $1}' | sort -u | tr '\n' ' ')
                tooltip+="  → Used by: $processes\\n"   # Show active processes
            else
                tooltip+="  → Available\\n"             # Device ready for use
            fi
        done
    else
        #───────────────────────────────────────────────────────────────────────
        # NO DEVICES FOUND - DIAGNOSTIC INFORMATION
        # Provide helpful troubleshooting information when no devices detected
        #───────────────────────────────────────────────────────────────────────
        
        tooltip+="No video devices found\\n"
        
        if [[ $usb_cameras -gt 0 ]]; then
            # USB camera detected but no video devices (likely F6 disabled)
            tooltip+="(USB camera detected but disabled - try F6 key)\\n"
        else
            # No camera hardware detected at system level
            tooltip+="(No camera hardware detected)\\n"
        fi
    fi
    
    # Output formatted tooltip with escape sequences for newlines
    echo -e "$tooltip"
}

#───────────────────────────────────────────────────────────────────────────────
# COMMAND LINE INTERFACE AND ARGUMENT PROCESSING
# Handle different script invocation modes for Waybar integration
#───────────────────────────────────────────────────────────────────────────────

case "$1" in
    "status")
        # Return formatted status icon for Waybar display
        get_camera_status
        ;;
    "tooltip")
        # Return detailed information for Waybar tooltip
        show_camera_tooltip
        ;;
    *)
        # Default behavior: return status (backward compatibility)
        get_camera_status
        ;;
esac

#═══════════════════════════════════════════════════════════════════════════════
# END OF CAMERA STATUS MONITOR
#
# This script provides comprehensive camera monitoring for Waybar with:
# • Real-time status detection and visual indicators
# • Hardware presence verification through multiple methods
# • Active usage monitoring via process tracking
# • Detailed tooltip information for troubleshooting
# • F6 function key integration for hardware toggle support
#
# USAGE EXAMPLES:
# ./camera.sh status    # Get status icon for Waybar
# ./camera.sh tooltip   # Get detailed tooltip information
# ./camera.sh           # Default to status mode
#
# TROUBLESHOOTING:
# • Ensure v4l2-utils package is installed for v4l2-ctl
# • Check camera permissions: usermod -a -G video $USER
# • Verify F6 key script integration for hardware toggle
# • Test individual commands: lsusb, lsof /dev/video0, lsmod
#
# Space Station Development Environment | Camera Monitoring Suite
#═══════════════════════════════════════════════════════════════════════════════
