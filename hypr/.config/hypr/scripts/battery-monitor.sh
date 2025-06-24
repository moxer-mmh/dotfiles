#!/bin/bash
#═══════════════════════════════════════════════════════════════════════════════
# 🔋 COSMIC BATTERY MONITOR - SPACE STATION POWER MANAGEMENT
#═══════════════════════════════════════════════════════════════════════════════
#
# A smart battery monitoring system designed for optimal laptop battery health
# in the cosmic-themed development environment. Provides intelligent notifications
# and monitoring to maintain battery longevity and performance.
#
# FEATURES:
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ • 80% charge threshold notifications for battery health optimization         │
# │ • Continuous monitoring with configurable check intervals                   │
# │ • Smart notification system with duplicate prevention                       │
# │ • Multiple operation modes: monitor, check, status                          │
# │ • Visual and audio notification support                                     │
# │ • Automatic reset when unplugged from charging                              │
# │ • Fallback battery detection for various hardware configurations            │
# │ • Space station themed notifications with cosmic aesthetics                 │
# └─────────────────────────────────────────────────────────────────────────────┘
#
# BATTERY HEALTH SCIENCE:
# Lithium-ion batteries last longer when kept between 20-80% charge.
# This monitor helps maintain optimal battery health by alerting at 80%.
#
# USAGE MODES:
# ./battery-monitor.sh monitor    # Start continuous monitoring
# ./battery-monitor.sh check      # Single battery check
# ./battery-monitor.sh status     # Display current battery information
#
# DEPENDENCIES:
# - libnotify-bin (for desktop notifications)
# - /sys/class/power_supply/BAT* (Linux battery interface)
# - Optional: PulseAudio/ALSA for sound notifications
#
# INTEGRATION:
# - Can be started via Hyprland autostart
# - Works with systemd user services
# - Compatible with cron for scheduled checks
#
# AUTHOR: Space Station Development Environment
# THEME: Cosmic Nebula Configuration Suite
# VERSION: 1.0.0
# LAST UPDATED: June 2025
#
#═══════════════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────────────
# CONFIGURATION CONSTANTS
#───────────────────────────────────────────────────────────────────────────────

# Primary battery path - most laptops use BAT1, some use BAT0
BATTERY_PATH="/sys/class/power_supply/BAT1"

# Target charge percentage for battery health optimization
# 80% is the scientifically recommended maximum for lithium-ion longevity
TARGET_CHARGE=80

# Notification state file to prevent spam notifications
# Ensures only one notification per charging session
NOTIFY_SENT_FILE="/tmp/.battery_80_notified"

# Check interval for continuous monitoring (in seconds)
# 30 seconds provides good responsiveness without excessive CPU usage
CHECK_INTERVAL=30

# Sound notification file (uncomment to enable audio alerts)
# SOUND_FILE="/usr/share/sounds/alsa/Front_Left.wav"

#───────────────────────────────────────────────────────────────────────────────
# BATTERY INFORMATION FUNCTIONS
# Core functions for retrieving battery status and charge level information
#───────────────────────────────────────────────────────────────────────────────

# Get current battery charge level as percentage (0-100)
# Returns: Integer percentage value or "0" if battery not found
# Usage: current_level=$(get_battery_level)
get_battery_level() {
    # Check if the battery capacity file exists
    if [[ -f "$BATTERY_PATH/capacity" ]]; then
        cat "$BATTERY_PATH/capacity"
    else
        # Try fallback battery paths for different hardware configurations
        for bat_path in /sys/class/power_supply/BAT*; do
            if [[ -f "$bat_path/capacity" ]]; then
                cat "$bat_path/capacity"
                return
            fi
        done
        # Return 0 if no battery found
        echo "0"
    fi
}

# Get current battery charging status
# Returns: "Charging", "Discharging", "Full", "Not charging", or "Unknown"
# Usage: status=$(get_battery_status)
get_battery_status() {
    # Check if the battery status file exists
    if [[ -f "$BATTERY_PATH/status" ]]; then
        cat "$BATTERY_PATH/status"
    else
        # Try fallback battery paths for different hardware configurations
        for bat_path in /sys/class/power_supply/BAT*; do
            if [[ -f "$bat_path/status" ]]; then
                cat "$bat_path/status"
                return
            fi
        done
        # Return Unknown if no battery found
        echo "Unknown"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# BATTERY MONITORING LOGIC
# Core monitoring functions with smart notification handling
#───────────────────────────────────────────────────────────────────────────────

# Check battery status and send notifications when threshold is reached
# This function implements the core battery health monitoring logic:
# 1. Gets current charge level and charging status
# 2. Checks if battery has reached the target threshold while charging
# 3. Sends notification only once per charging session (prevents spam)
# 4. Resets notification flag when unplugged from charger
# 5. Provides visual feedback with battery icon and cosmic theme
check_battery() {
    # Get current battery information
    local current_charge=$(get_battery_level)
    local battery_status=$(get_battery_status)
    
    # Validate battery information
    if [[ "$current_charge" == "0" && "$battery_status" == "Unknown" ]]; then
        echo "⚠️  Warning: No battery detected or battery information unavailable"
        return 1
    fi
    
    # Check if we've reached the target charge while charging
    if [[ "$battery_status" == "Charging" ]] && [[ "$current_charge" -ge "$TARGET_CHARGE" ]]; then
        # Send notification only if we haven't already notified this session
        if [[ ! -f "$NOTIFY_SENT_FILE" ]]; then
            # Send desktop notification with cosmic theme
            notify-send "🚀 Space Station Battery Alert" \
                "🔋 Battery reached ${current_charge}%! Consider unplugging to maintain battery health.\n\n⚡ Optimal charge range: 20-80%\n🛡️  Protecting battery longevity" \
                -i battery-full-charged \
                -u normal \
                -t 10000 \
                -c "battery-health"
            
            # Mark notification as sent for this charging session
            touch "$NOTIFY_SENT_FILE"
            
            # Optional: Play notification sound (uncomment to enable)
            # if [[ -n "$SOUND_FILE" && -f "$SOUND_FILE" ]]; then
            #     paplay "$SOUND_FILE" 2>/dev/null &
            # fi
            
            # Log the notification event
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Battery notification sent: ${current_charge}%" >> /tmp/battery-monitor.log
        fi
    elif [[ "$battery_status" != "Charging" ]]; then
        # Reset notification flag when not charging (allows new notifications when plugged back in)
        if [[ -f "$NOTIFY_SENT_FILE" ]]; then
            rm -f "$NOTIFY_SENT_FILE" 2>/dev/null
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Notification flag reset (unplugged)" >> /tmp/battery-monitor.log
        fi
    fi
    
    return 0
}

# Continuous battery monitoring loop for daemon-style operation
# This function runs indefinitely, checking battery status at regular intervals
# Designed to be lightweight and efficient for background operation
# Usage: Run as background service or integrate with system startup
monitor_battery() {
    echo "🚀 Starting Cosmic Battery Monitor for Space Station..."
    echo "🔋 Target charge threshold: ${TARGET_CHARGE}%"
    echo "⏱️  Check interval: ${CHECK_INTERVAL} seconds"
    echo "📁 Notification state file: ${NOTIFY_SENT_FILE}"
    echo "📊 Battery path: ${BATTERY_PATH}"
    echo ""
    echo "🛡️  Battery health monitoring active - protecting your battery longevity!"
    echo "Press Ctrl+C to stop monitoring..."
    echo ""
    
    # Initialize monitoring loop
    local loop_count=0
    while true; do
        # Perform battery check
        check_battery
        
        # Display periodic status updates (every 10 checks = ~5 minutes)
        if (( loop_count % 10 == 0 )); then
            local current_level=$(get_battery_level)
            local current_status=$(get_battery_status)
            echo "$(date '+%H:%M:%S') - Battery: ${current_level}% (${current_status})"
        fi
        
        # Increment loop counter
        ((loop_count++))
        
        # Wait for next check interval
        sleep "$CHECK_INTERVAL"
    done
}

#───────────────────────────────────────────────────────────────────────────────
# COMMAND LINE INTERFACE
# Main script entry point with multiple operation modes
#───────────────────────────────────────────────────────────────────────────────

# Display detailed battery status information
show_battery_status() {
    local current_level=$(get_battery_level)
    local current_status=$(get_battery_status)
    local notification_active="No"
    
    # Check if notification has been sent
    if [[ -f "$NOTIFY_SENT_FILE" ]]; then
        notification_active="Yes (since $(stat -c %y "$NOTIFY_SENT_FILE" | cut -d' ' -f1-2))"
    fi
    
    echo "🚀 Cosmic Battery Monitor - Space Station Status Report"
    echo "════════════════════════════════════════════════════════"
    echo "🔋 Current Battery Level: ${current_level}%"
    echo "⚡ Charging Status: ${current_status}"
    echo "🎯 Target Threshold: ${TARGET_CHARGE}%"
    echo "🔔 Notification Sent: ${notification_active}"
    echo "📁 Battery Path: ${BATTERY_PATH}"
    echo "⏱️  Check Interval: ${CHECK_INTERVAL} seconds"
    echo ""
    
    # Battery health assessment
    if [[ "$current_level" -gt 80 ]]; then
        echo "⚠️  Battery Health Alert: Consider unplugging to maintain longevity"
    elif [[ "$current_level" -lt 20 ]]; then
        echo "🔌 Battery Low: Consider charging to prevent deep discharge"
    else
        echo "✅ Battery in optimal range (20-80%)"
    fi
    
    # Display additional system information
    echo ""
    echo "💡 Battery Health Tips:"
    echo "   • Keep battery between 20-80% for maximum lifespan"
    echo "   • Avoid extreme temperatures during charging"
    echo "   • Unplug when reaching 80% to prevent overcharging stress"
    echo "   • Perform full discharge cycles occasionally (monthly)"
}

# Parse command line arguments and execute appropriate actions
case "$1" in
    "monitor")
        # Start continuous monitoring mode (daemon-style operation)
        monitor_battery
        ;;
    "check")
        # Perform single battery check and exit
        echo "🔍 Performing single battery check..."
        check_battery
        local exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            echo "✅ Battery check completed successfully"
        else
            echo "❌ Battery check failed"
        fi
        exit $exit_code
        ;;
    "status")
        # Display comprehensive battery status information
        show_battery_status
        ;;
    "help"|"-h"|"--help")
        # Display comprehensive help information
        echo "🚀 Cosmic Battery Monitor - Space Station Power Management"
        echo "═════════════════════════════════════════════════════════════"
        echo ""
        echo "DESCRIPTION:"
        echo "  Intelligent battery health monitoring system designed to optimize"
        echo "  lithium-ion battery longevity through smart charge management."
        echo ""
        echo "USAGE:"
        echo "  $0 <command>"
        echo ""
        echo "COMMANDS:"
        echo "  monitor    Start continuous battery monitoring (daemon mode)"
        echo "  check      Perform single battery check and exit"
        echo "  status     Display detailed battery status information"
        echo "  help       Show this help message"
        echo ""
        echo "EXAMPLES:"
        echo "  $0 monitor                    # Start background monitoring"
        echo "  $0 check                      # Quick battery check"
        echo "  $0 status                     # Detailed battery report"
        echo ""
        echo "INTEGRATION:"
        echo "  # Add to Hyprland autostart:"
        echo "  exec-once = ~/.config/hypr/scripts/battery-monitor.sh monitor"
        echo ""
        echo "  # Create systemd user service:"
        echo "  systemctl --user enable battery-monitor.service"
        echo ""
        echo "BATTERY HEALTH SCIENCE:"
        echo "  • Lithium-ion batteries last longer when kept between 20-80%"
        echo "  • Overcharging creates heat and stress on battery chemistry"
        echo "  • 80% charge limit can extend battery lifespan by 2-4x"
        echo "  • This monitor helps maintain optimal charging habits"
        echo ""
        ;;
    *)
        # Default case: show usage information
        echo "🔋 Cosmic Battery Monitor - Space Station Power Management"
        echo "Usage: $0 {monitor|check|status|help}"
        echo ""
        echo "Quick start:"
        echo "  $0 monitor    # Start continuous monitoring"
        echo "  $0 status     # Check current battery status"
        echo "  $0 help       # Show detailed help"
        echo ""
        echo "🛡️  Protecting your battery health with science-based charge management!"
        ;;
esac

#═══════════════════════════════════════════════════════════════════════════════
# 📊 COSMIC BATTERY MONITOR SUMMARY & INTEGRATION GUIDE
#═══════════════════════════════════════════════════════════════════════════════
#
# BATTERY HEALTH BENEFITS:
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ 🔬 SCIENTIFIC BENEFITS:                                                      │
# │ • Extends battery lifespan by 2-4x through optimal charge management        │
# │ • Reduces chemical stress on lithium-ion cells                              │
# │ • Minimizes heat generation during charging cycles                          │
# │ • Prevents capacity degradation from overcharging                           │
# │ • Maintains stable voltage levels for consistent performance                 │
# │                                                                             │
# │ 📈 PERFORMANCE BENEFITS:                                                     │
# │ • Consistent battery performance over years of use                          │
# │ • Reduced need for battery replacements                                     │
# │ • Lower operating temperatures during charging                              │
# │ • Improved power delivery stability                                         │
# │ • Enhanced laptop mobility and productivity                                 │
# └─────────────────────────────────────────────────────────────────────────────┘
#
# INTEGRATION EXAMPLES:
#
# 1. HYPRLAND AUTOSTART INTEGRATION:
#    Add to ~/.config/hypr/hyprland.conf:
#    exec-once = ~/.config/hypr/scripts/battery-monitor.sh monitor
#
# 2. SYSTEMD USER SERVICE:
#    Create ~/.config/systemd/user/battery-monitor.service:
#    [Unit]
#    Description=Cosmic Battery Health Monitor
#    After=graphical-session.target
#    
#    [Service]
#    Type=simple
#    ExecStart=/home/%i/.config/hypr/scripts/battery-monitor.sh monitor
#    Restart=always
#    RestartSec=10
#    
#    [Install]
#    WantedBy=default.target
#
# 3. CRON SCHEDULED CHECKS:
#    Add to crontab for periodic checks:
#    */5 * * * * ~/.config/hypr/scripts/battery-monitor.sh check
#
# 4. MANUAL KEYBINDING:
#    Add to Hyprland config for instant status:
#    bind = $mainMod, F12, exec, ~/.config/hypr/scripts/battery-monitor.sh status
#
# TROUBLESHOOTING:
#
# • No Battery Detected:
#   - Check /sys/class/power_supply/ for available battery paths
#   - Update BATTERY_PATH variable to match your system (BAT0, BAT1, etc.)
#   - Ensure proper permissions to read battery information files
#
# • Notifications Not Appearing:
#   - Verify libnotify-bin is installed: sudo apt install libnotify-bin
#   - Check if notification daemon is running: ps aux | grep notification
#   - Test manually: notify-send "Test" "Battery monitor test"
#
# • Script Not Starting:
#   - Make script executable: chmod +x battery-monitor.sh
#   - Check script location and paths are correct
#   - Verify bash is available: which bash
#
# • False Battery Readings:
#   - Some laptops have multiple battery paths
#   - Check all paths in /sys/class/power_supply/BAT*
#   - Update script to use correct battery interface
#
# CUSTOMIZATION OPTIONS:
#
# • Change Target Threshold:
#   TARGET_CHARGE=85  # Set to 85% instead of 80%
#
# • Adjust Check Interval:
#   CHECK_INTERVAL=60  # Check every minute instead of 30 seconds
#
# • Enable Sound Notifications:
#   SOUND_FILE="/usr/share/sounds/alsa/Front_Left.wav"
#   # Uncomment sound playing line in check_battery function
#
# • Custom Notification Messages:
#   Modify the notify-send command in check_battery function
#   Add additional notification categories or urgency levels
#
# BATTERY TECHNOLOGY REFERENCE:
#
# Lithium-ion Battery Chemistry:
# • Optimal voltage range: 3.2V - 4.0V per cell
# • Capacity degradation accelerates above 4.0V (>80% charge)
# • Deep discharge below 3.0V causes permanent damage
# • Temperature affects charging efficiency and longevity
# • Charge cycles: 1 cycle = 0% to 100% (partial charges count proportionally)
#
# Charging Best Practices:
# • Shallow discharges are better than deep discharges
# • Frequent partial charges are preferable to full cycles
# • Avoid leaving battery at 100% charge for extended periods
# • Keep battery cool during charging (avoid direct sunlight/heat)
# • Perform occasional full discharge cycles for calibration
#
# Expected Battery Lifespan:
# • Standard usage (no optimization): 300-500 cycles (~2-3 years)
# • With 80% charge limit: 800-1200 cycles (~4-6 years)
# • Cycle count varies by battery quality and usage patterns
#
# FUTURE ENHANCEMENTS:
#
# Potential improvements for advanced users:
# • Integration with laptop power management tools (TLP, auto-cpufreq)
# • Web dashboard for battery health tracking over time
# • Machine learning-based charging pattern optimization
# • Integration with calendar for smart charging before meetings
# • Temperature monitoring and thermal-based charge adjustment
# • Battery wear level tracking and replacement predictions
# • Integration with smart home systems for charging automation
#
#═══════════════════════════════════════════════════════════════════════════════
# END OF COSMIC BATTERY MONITOR
# May your battery live long and prosper! 🚀🔋✨
#═══════════════════════════════════════════════════════════════════════════════
