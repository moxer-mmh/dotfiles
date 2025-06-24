#!/bin/bash
# =============================================================================
# 🚀 SPACE STATION WALLPAPER CYCLING SCRIPT 🚀
# Automated cosmic wallpaper rotation with seamless transitions
# =============================================================================
# 
# This script provides automated wallpaper cycling with:
# - Random wallpaper selection from configured directory
# - Smooth fade transitions using SWWW (Wayland wallpaper daemon)
# - Dynamic symlink updates for Hyprlock integration
# - Configurable cycling intervals and image formats
# - Automatic reshuffling to prevent repetitive patterns
# - Real-time Hyprlock wallpaper reload support
#
# Dependencies:
#   - swww (Wayland wallpaper daemon)
#   - find (file discovery)
#   - ln (symlink creation)
#   - pkill (process signaling)
#
# Author: moxer_mmh
# Last Updated: June 2025
# Compatible with: SWWW 0.8+, Hyprland/Wayland
# =============================================================================

# -----------------------------------------------------------------------------
# CONFIGURATION VARIABLES
# Customize these paths and settings for your environment
# -----------------------------------------------------------------------------
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"    # Source directory for wallpaper images
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"  # Symlink for active wallpaper
INTERVAL=30  # Cycling interval in seconds (30s = smooth rotation without distraction)

# -----------------------------------------------------------------------------
# WALLPAPER APPLICATION FUNCTION
# Handles the complete wallpaper switching process
# -----------------------------------------------------------------------------
set_wallpaper() {
    local wallpaper="$1"  # Input: Full path to wallpaper image file

    # Step 1: Update symlink for Hyprlock integration
    # This allows Hyprlock to automatically use the current wallpaper
    ln -sf "$wallpaper" "$CURRENT_WALLPAPER"

    # Step 2: Apply wallpaper using SWWW with smooth transition
    # --transition-type fade: Smooth fade between wallpapers (cosmic effect)
    # --transition-duration 2: 2-second transition for seamless experience
    swww img "$wallpaper" --transition-type fade --transition-duration 2

    # Step 3: Signal Hyprlock to reload wallpaper (if currently running)
    # USR2 signal triggers wallpaper reload without disrupting lock screen
    # 2>/dev/null suppresses error if hyprlock is not running
    pkill -USR2 hyprlock 2>/dev/null
}

# -----------------------------------------------------------------------------
# MAIN WALLPAPER CYCLING FUNCTION
# Discovers, randomizes, and cycles through wallpaper collection
# -----------------------------------------------------------------------------
cycle_wallpapers() {
    # Step 1: Discover all supported image files and randomize order
    # Supported formats: JPEG (.jpg, .jpeg) and PNG (.png)
    # | shuf: Randomizes the order to prevent predictable patterns
    mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf)

    # Step 2: Validate wallpaper collection
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "❌ No wallpapers found in $WALLPAPER_DIR"
        echo "📁 Please add .jpg, .jpeg, or .png files to the wallpaper directory"
        return 1
    fi

    # Step 3: Initialize cosmic cycling process
    echo "🌌 Starting cosmic wallpaper cycle with ${#wallpapers[@]} wallpapers"
    echo "⏱️  Interval: ${INTERVAL} seconds per wallpaper"
    echo "📂 Source: $WALLPAPER_DIR"

    # Step 4: Infinite cycling loop with reshuffling
    while true; do
        # Cycle through current wallpaper array
        for wallpaper in "${wallpapers[@]}"; do
            echo "🖼️  Setting wallpaper: $(basename "$wallpaper")"
            set_wallpaper "$wallpaper"
            
            # Wait for configured interval before next wallpaper
            sleep "$INTERVAL"
        done
        
        # Step 5: Reshuffle wallpapers after each complete cycle
        # This prevents the same sequence from repeating and keeps it interesting
        echo "🔄 Reshuffling wallpaper order for next cycle..."
        mapfile -t wallpapers < <(printf '%s\n' "${wallpapers[@]}" | shuf)
    done
}

# -----------------------------------------------------------------------------
# SCRIPT EXECUTION
# Initialize the cosmic wallpaper cycling process
# -----------------------------------------------------------------------------
echo "🚀 Initializing Space Station Wallpaper System..."
echo "📡 Checking dependencies and configuration..."

# Validate wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "❌ Error: Wallpaper directory does not exist: $WALLPAPER_DIR"
    echo "📁 Please create the directory and add wallpaper images"
    exit 1
fi

# Validate SWWW daemon is available
if ! command -v swww >/dev/null 2>&1; then
    echo "❌ Error: SWWW wallpaper daemon not found"
    echo "📦 Please install SWWW: sudo pacman -S swww"
    exit 1
fi

# Start the cosmic wallpaper cycling
cycle_wallpapers

# =============================================================================
# 📋 WALLPAPER CYCLING SYSTEM SUMMARY
# =============================================================================
#
# CYCLING PROCESS FLOW:
#
# 1. 🔍 DISCOVERY PHASE:
#    └── Scan ~/Pictures/Wallpapers/ for image files
#    └── Filter: .jpg, .jpeg, .png formats
#    └── Randomize order with shuf command
#    └── Validate collection (exit if empty)
#
# 2. 🔄 CYCLING PHASE:
#    └── Apply wallpaper with SWWW fade transition
#    └── Update symlink for Hyprlock integration
#    └── Signal Hyprlock to reload (if running)
#    └── Wait 30 seconds before next wallpaper
#
# 3. 🔀 RESHUFFLE PHASE:
#    └── After each complete cycle through all wallpapers
#    └── Randomize order again to prevent repetition
#    └── Continue infinite cycling loop
#
# =============================================================================
# 🎨 INTEGRATION WITH COSMIC ECOSYSTEM
# =============================================================================
#
# 🖼️ HYPRLAND INTEGRATION:
#   • Uses SWWW daemon for Wayland wallpaper management
#   • Smooth fade transitions (2-second duration)
#   • Real-time wallpaper updates across all monitors
#
# 🔒 HYPRLOCK INTEGRATION:
#   • Creates symlink at ~/.config/hypr/current_wallpaper
#   • Hyprlock automatically uses current wallpaper as background
#   • USR2 signal triggers immediate reload during lock screen
#
# 🌌 COSMIC AESTHETIC:
#   • Space-themed output messages and emojis
#   • Seamless transitions maintain cosmic atmosphere
#   • Non-disruptive timing (30-second intervals)
#
# =============================================================================
# ⚙️ CONFIGURATION OPTIONS
# =============================================================================
#
# 📁 WALLPAPER DIRECTORY:
#   Default: ~/Pictures/Wallpapers/
#   Modify: Change WALLPAPER_DIR variable
#   
# ⏱️ CYCLING INTERVAL:
#   Default: 30 seconds
#   Modify: Change INTERVAL variable
#   Recommendations:
#     • 15s: Fast cycling (demo/testing)
#     • 30s: Balanced (default)
#     • 60s: Slow cycling (focus-friendly)
#     • 300s: Very slow (5 minutes)
#
# 🎭 TRANSITION EFFECTS:
#   Current: fade (2-second duration)
#   Alternatives: wipe, left, right, top, bottom, center
#   Modify: Change --transition-type in set_wallpaper()
#
# 🖼️ SUPPORTED FORMATS:
#   Current: .jpg, .jpeg, .png
#   Add formats: Modify find command pattern
#   Example: Add .webp: -o -iname "*.webp"
#
# =============================================================================
# 🚀 USAGE AND DEPLOYMENT
# =============================================================================
#
# 📋 MANUAL EXECUTION:
#   chmod +x ~/.config/hypr/scripts/wallpaper-cycle.sh
#   ~/.config/hypr/scripts/wallpaper-cycle.sh
#
# 🔄 AUTOMATIC STARTUP:
#   Add to hyprland.conf:
#   exec-once = ~/.config/hypr/scripts/wallpaper-cycle.sh &
#
# 🛑 STOP CYCLING:
#   pkill -f wallpaper-cycle.sh
#
# 📊 MONITOR STATUS:
#   ps aux | grep wallpaper-cycle
#   tail -f /tmp/wallpaper-cycle.log  # if logging added
#
# =============================================================================
# 🛠️ TROUBLESHOOTING GUIDE
# =============================================================================
#
# ❌ COMMON ISSUES:
#
# 1. "No wallpapers found":
#    • Check if ~/Pictures/Wallpapers/ exists
#    • Verify images are .jpg, .jpeg, or .png format
#    • Check file permissions (readable)
#
# 2. "SWWW daemon not found":
#    • Install SWWW: sudo pacman -S swww
#    • Start SWWW daemon: swww init
#    • Verify: swww query
#
# 3. "Wallpaper not changing":
#    • Check if SWWW daemon is running: swww query
#    • Verify script has execute permissions
#    • Check for error messages in terminal output
#
# 4. "Hyprlock not updating":
#    • Verify symlink exists: ls -la ~/.config/hypr/current_wallpaper
#    • Check Hyprlock reload_time setting (should be > 0)
#    • Ensure Hyprlock is running: pidof hyprlock
#
# =============================================================================
# 🎯 PERFORMANCE CONSIDERATIONS
# =============================================================================
#
# 💾 MEMORY USAGE:
#   • Minimal: Script uses ~1-2MB RAM
#   • SWWW daemon: ~10-20MB RAM (normal)
#   • Image cache: Managed by SWWW automatically
#
# 🖥️ CPU IMPACT:
#   • Negligible during steady state
#   • Brief spike during transition (2 seconds)
#   • No impact on system performance
#
# 📊 STORAGE CONSIDERATIONS:
#   • Wallpaper directory size affects startup time
#   • Recommended: 50-200 wallpapers for good variety
#   • Large images (>4K) may slow transitions slightly
#
# =============================================================================
# 🔮 FUTURE ENHANCEMENT IDEAS
# =============================================================================
#
# 🌅 TIME-BASED CYCLING:
#   • Morning: Bright, energetic wallpapers
#   • Evening: Dark, cosmic wallpapers
#   • Night: Minimal, dark wallpapers
#
# 🎨 THEME INTEGRATION:
#   • Match wallpapers to current color scheme
#   • Seasonal wallpaper collections
#   • Mood-based selections
#
# 📱 REMOTE CONTROL:
#   • Skip to next wallpaper via keybinding
#   • Favorite/blacklist wallpapers
#   • Web interface for management
#
# 🤖 INTELLIGENT SELECTION:
#   • Learn from user preferences
#   • Avoid recently used wallpapers
#   • Smart shuffling algorithms
#
# =============================================================================

