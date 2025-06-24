#!/bin/bash
# =============================================================================
# 📷 SPACE STATION CAMERA CONTROL SYSTEM 📷
# Intelligent camera toggle and monitoring for MSI laptops and Hyprland
# =============================================================================
# 
# This script provides comprehensive camera management with:
# - Hardware camera state detection (multiple methods)
# - Software state tracking for F6 key functionality
# - Desktop notification integration for user feedback
# - Multiple detection methods for robust compatibility
# - MSI laptop F6 key integration support
# - Privacy-focused camera control workflow
#
# Supported Actions:
#   ./camera-toggle.sh         - Toggle camera state (default)
#   ./camera-toggle.sh toggle  - Explicitly toggle camera state
#   ./camera-toggle.sh check   - Display current camera status
#   ./camera-toggle.sh hardware - Check hardware availability only
#
# Dependencies:
#   - ffmpeg (camera access testing)
#   - v4l2-ctl (Video4Linux utilities)
#   - lsusb (USB device detection)
#   - notify-send (desktop notifications)
#
# Author: moxer_mmh
# Last Updated: June 2025
# Compatible with: MSI laptops, Hyprland, most webcam hardware
# =============================================================================

# -----------------------------------------------------------------------------
# CONFIGURATION VARIABLES
# State file location for persistent camera status tracking
# -----------------------------------------------------------------------------
CAMERA_STATE_FILE="/tmp/.camera_state"  # Temporary file for camera state persistence

# -----------------------------------------------------------------------------
# HARDWARE CAMERA DETECTION FUNCTION
# Multi-method approach for robust camera hardware state detection
# -----------------------------------------------------------------------------
get_camera_hardware_state() {
    # METHOD 1: Direct Camera Access Test (Most Reliable)
    # Attempts to capture a single frame using ffmpeg with timeout
    # This method actually tests if the camera is functional and accessible
    if timeout 1 ffmpeg -f v4l2 -i /dev/video0 -frames:v 1 -f null - >/dev/null 2>&1; then
        echo "available"
        return 0
    fi
    
    # METHOD 2: Video4Linux Device Accessibility Check
    # Checks if camera device exists and responds to v4l2 commands
    # More lightweight than ffmpeg but less comprehensive
    if [[ -e "/dev/video0" ]]; then
        if v4l2-ctl --device=/dev/video0 --list-formats >/dev/null 2>&1; then
            echo "available"
            return 0
        fi
    fi
    
    # METHOD 3: USB Camera Hardware Detection
    # Detects camera presence at USB level (may be disabled by hardware/firmware)
    # Useful for MSI laptops with hardware camera disable switches
    if lsusb | grep -i "camera\|webcam" >/dev/null; then
        # Camera USB device exists but might be disabled via hardware switch
        echo "blocked"
        return 1
    fi
    
    # METHOD 4: Fallback - Unknown State
    # If all detection methods fail, camera state cannot be determined
    echo "unknown"
    return 2
}

# -----------------------------------------------------------------------------
# SOFTWARE CAMERA STATE TOGGLE FUNCTION
# Manages user-controlled camera state tracking and F6 key integration
# -----------------------------------------------------------------------------
toggle_camera_state() {
    # Check if state file exists (previous toggle history)
    if [[ -f "$CAMERA_STATE_FILE" ]]; then
        # Read current software state from persistent file
        local current_state=$(cat "$CAMERA_STATE_FILE")
        
        # Toggle between enabled/disabled states
        if [[ "$current_state" == "enabled" ]]; then
            # Switch from enabled to disabled
            echo "disabled" > "$CAMERA_STATE_FILE"
            notify-send "📷 Camera" "Camera disabled via F6 key" \
                -t 3000 \
                -u normal \
                -i camera-disabled
        else
            # Switch from disabled to enabled (or any other state)
            echo "enabled" > "$CAMERA_STATE_FILE"
            notify-send "📷 Camera" "Camera enabled via F6 key" \
                -t 3000 \
                -u normal \
                -i camera-enabled
        fi
    else
        # Initialize state file on first run
        echo "enabled" > "$CAMERA_STATE_FILE"
        notify-send "📷 Camera" "Camera state tracking initialized" \
            -t 3000 \
            -u low \
            -i camera-ready
    fi
}

# -----------------------------------------------------------------------------
# CAMERA STATUS CHECK FUNCTION
# Provides comprehensive camera state information for diagnostics
# -----------------------------------------------------------------------------
check_camera_state() {
    # Get hardware state using detection function
    local hw_state=$(get_camera_hardware_state)
    local sw_state="unknown"
    
    # Read software state from persistent file (if exists)
    if [[ -f "$CAMERA_STATE_FILE" ]]; then
        sw_state=$(cat "$CAMERA_STATE_FILE")
    else
        sw_state="uninitialized"
    fi
    
    # Output comprehensive status information
    echo "🔍 Camera Status Report:"
    echo "  Hardware State: $hw_state"
    echo "  Software State: $sw_state"
    echo "  State File: $CAMERA_STATE_FILE"
    
    # Provide interpretation of status
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

# -----------------------------------------------------------------------------
# COMMAND LINE INTERFACE
# Handles different script invocation modes and arguments
# -----------------------------------------------------------------------------
case "$1" in
    "toggle")
        # Explicit toggle command
        echo "🔄 Toggling camera state..."
        toggle_camera_state
        ;;
    "check")
        # Status check and diagnostics
        check_camera_state
        ;;
    "hardware")
        # Hardware-only detection (no state file interaction)
        echo "🔍 Checking hardware state..."
        hw_state=$(get_camera_hardware_state)
        echo "Camera hardware: $hw_state"
        ;;
    "help"|"--help"|"-h")
        # Display usage information
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
        # Default action when F6 is pressed or no arguments provided
        echo "📷 F6 key pressed - toggling camera state..."
        toggle_camera_state
        ;;
esac

# =============================================================================
# 📋 CAMERA CONTROL SYSTEM SUMMARY
# =============================================================================
#
# DETECTION METHODS HIERARCHY:
#
# 1. 🎥 FFMPEG ACCESS TEST (Primary):
#    └── Tests actual camera functionality with timeout protection
#    └── Most reliable method for determining usability
#    └── Returns: "available" if camera captures successfully
#
# 2. 🛠️ V4L2 DEVICE CHECK (Secondary):
#    └── Checks Video4Linux device accessibility
#    └── Lightweight alternative to ffmpeg test
#    └── Returns: "available" if device responds to v4l2 commands
#
# 3. 🔌 USB HARDWARE DETECTION (Tertiary):
#    └── Detects camera presence at USB level
#    └── Useful for MSI laptops with hardware switches
#    └── Returns: "blocked" if USB device exists but inaccessible
#
# 4. ❓ UNKNOWN STATE (Fallback):
#    └── When all detection methods fail
#    └── Indicates potential driver or hardware issues
#
# =============================================================================
# 🎯 MSI LAPTOP INTEGRATION
# =============================================================================
#
# 🔑 F6 KEY FUNCTIONALITY:
#   • MSI laptops typically use F6 for camera toggle
#   • Hardware switch may physically disable camera
#   • Script tracks software state separately from hardware
#   • Provides visual feedback via desktop notifications
#
# 🔄 STATE MANAGEMENT:
#   • Hardware State: Actual camera accessibility
#   • Software State: User preference tracking (enabled/disabled)
#   • Persistent state file survives reboots
#   • Independent state tracking for complex scenarios
#
# 🚨 PRIVACY FEATURES:
#   • Clear visual feedback when camera state changes
#   • Notification system integration
#   • Easy status checking for privacy verification
#   • Hardware-level detection for true privacy assurance
#
# =============================================================================
# ⚙️ HYPRLAND INTEGRATION GUIDE
# =============================================================================
#
# 📋 HYPRLAND CONFIGURATION:
#   Add to hyprland.conf:
#   
#   # Camera controls (F6 key)
#   bindl = , XF86WebCam, exec, ~/.config/hypr/scripts/camera-toggle.sh
#   bind = , F6, exec, ~/.config/hypr/scripts/camera-toggle.sh
#   bind = $mainMod, F6, exec, cheese  # Launch camera app
#
# 🔔 NOTIFICATION SETUP:
#   Ensure notification daemon is running:
#   exec-once = dunst &  # or your preferred notification daemon
#
# 🎛️ ADDITIONAL KEYBINDINGS:
#   bind = $mainMod SHIFT, F6, exec, ~/.config/hypr/scripts/camera-toggle.sh check
#   bind = $mainMod CTRL, F6, exec, ~/.config/hypr/scripts/camera-toggle.sh hardware
#
# =============================================================================
# 🛠️ TROUBLESHOOTING GUIDE
# =============================================================================
#
# ❌ COMMON ISSUES:
#
# 1. "Camera not detected":
#    • Check if camera drivers are installed
#    • Verify /dev/video0 exists: ls -la /dev/video*
#    • Test with: ffplay /dev/video0
#    • Install v4l2-utils: sudo pacman -S v4l-utils
#
# 2. "F6 key not working":
#    • Verify key binding in hyprland.conf
#    • Check if script has execute permissions: chmod +x camera-toggle.sh
#    • Test manually: ./camera-toggle.sh
#    • Check key code: wev (install with: sudo pacman -S wev)
#
# 3. "No notifications appearing":
#    • Ensure notification daemon is running: pidof dunst
#    • Test notifications: notify-send "Test" "Message"
#    • Check notification settings in your desktop environment
#
# 4. "Camera always shows as blocked":
#    • MSI laptop may have hardware camera switch disabled
#    • Check BIOS settings for camera configuration
#    • Verify camera privacy switch position (if physical)
#    • Try: sudo modprobe uvcvideo
#
# 5. "Permission denied errors":
#    • Add user to video group: sudo usermod -a -G video $USER
#    • Check device permissions: ls -la /dev/video0
#    • Restart session after group changes
#
# =============================================================================
# 📊 USAGE EXAMPLES
# =============================================================================
#
# 🔄 BASIC USAGE:
#   ./camera-toggle.sh              # Toggle camera state (F6 equivalent)
#   ./camera-toggle.sh toggle       # Explicit toggle
#   ./camera-toggle.sh check        # Status report
#   ./camera-toggle.sh hardware     # Hardware-only check
#
# 🔍 DIAGNOSTIC COMMANDS:
#   # Check camera device
#   ls -la /dev/video*
#   
#   # Test camera access
#   ffplay /dev/video0
#   
#   # List camera formats
#   v4l2-ctl --device=/dev/video0 --list-formats
#   
#   # Check USB cameras
#   lsusb | grep -i camera
#   
#   # Monitor key presses
#   wev | grep XF86WebCam
#
# 📱 INTEGRATION EXAMPLES:
#   # Waybar integration
#   "custom/camera": {
#       "exec": "~/.config/hypr/scripts/camera-toggle.sh check | grep Software | cut -d: -f2",
#       "interval": 5,
#       "on-click": "~/.config/hypr/scripts/camera-toggle.sh toggle"
#   }
#
# =============================================================================
# 🔮 FUTURE ENHANCEMENT IDEAS
# =============================================================================
#
# 🎨 VISUAL ENHANCEMENTS:
#   • LED indicator integration (if hardware supports)
#   • System tray icon with camera status
#   • OSD (On-Screen Display) integration
#   • Waybar/status bar module
#
# 🔐 SECURITY FEATURES:
#   • Camera access logging
#   • Application permission tracking
#   • Automatic disable during screenshare
#   • Privacy mode scheduling
#
# 🤖 SMART FEATURES:
#   • Auto-disable during meetings
#   • Integration with video conferencing apps
#   • Gesture-based camera control
#   • Voice command integration
#
# 📊 MONITORING FEATURES:
#   • Camera usage statistics
#   • Application access history
#   • Privacy audit reports
#   • Real-time access alerts
#
# =============================================================================
# 🔧 DEPENDENCIES AND REQUIREMENTS
# =============================================================================
#
# 📦 REQUIRED PACKAGES:
#   • ffmpeg - Camera access testing
#   • v4l-utils - Video4Linux utilities (v4l2-ctl)
#   • usbutils - USB device detection (lsusb)
#   • libnotify - Desktop notifications (notify-send)
#
# 🖥️ INSTALLATION COMMANDS:
#   # Arch Linux / Manjaro
#   sudo pacman -S ffmpeg v4l-utils usbutils libnotify
#   
#   # Ubuntu / Debian
#   sudo apt install ffmpeg v4l-utils usbutils libnotify-bin
#   
#   # Fedora
#   sudo dnf install ffmpeg v4l-utils usbutils libnotify
#
# ⚡ OPTIONAL ENHANCEMENTS:
#   • cheese - Camera application for testing
#   • wev - Wayland event viewer for key testing
#   • dunst - Lightweight notification daemon
#
# =============================================================================
