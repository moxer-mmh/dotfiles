#!/bin/bash
# 🔋 Battery Monitor for Space Station
# Provides notifications when battery reaches 80%

BATTERY_PATH="/sys/class/power_supply/BAT1"
TARGET_CHARGE=80
NOTIFY_SENT_FILE="/tmp/.battery_80_notified"

get_battery_level() {
    if [[ -f "$BATTERY_PATH/capacity" ]]; then
        cat "$BATTERY_PATH/capacity"
    else
        echo "0"
    fi
}

get_battery_status() {
    if [[ -f "$BATTERY_PATH/status" ]]; then
        cat "$BATTERY_PATH/status"
    else
        echo "Unknown"
    fi
}

check_battery() {
    local current_charge=$(get_battery_level)
    local battery_status=$(get_battery_status)
    
    if [[ "$battery_status" == "Charging" ]] && [[ "$current_charge" -ge "$TARGET_CHARGE" ]]; then
        if [[ ! -f "$NOTIFY_SENT_FILE" ]]; then
            notify-send "🔋 Space Station Battery Alert" \
                "Battery reached ${current_charge}%! Consider unplugging to maintain battery health." \
                -i battery-full-charged -u normal -t 10000
            touch "$NOTIFY_SENT_FILE"
            
            # Optional: Play a sound
            # paplay /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null &
        fi
    elif [[ "$battery_status" != "Charging" ]]; then
        # Reset notification flag when not charging
        rm -f "$NOTIFY_SENT_FILE" 2>/dev/null
    fi
}

# Monitor battery continuously
monitor_battery() {
    echo "🔋 Starting Battery Monitor for Space Station..."
    while true; do
        check_battery
        sleep 30  # Check every 30 seconds
    done
}

case "$1" in
    "monitor")
        monitor_battery
        ;;
    "check")
        check_battery
        ;;
    "status")
        echo "Battery Status:"
        echo "Level: $(get_battery_level)%"
        echo "Status: $(get_battery_status)"
        echo "Target: ${TARGET_CHARGE}%"
        ;;
    *)
        echo "🔋 Battery Monitor"
        echo "Usage: $0 {monitor|check|status}"
        ;;
esac
