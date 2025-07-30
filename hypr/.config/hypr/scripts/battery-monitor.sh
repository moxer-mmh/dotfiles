#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT1"

TARGET_CHARGE=80

NOTIFY_SENT_FILE="/tmp/.battery_80_notified"

CHECK_INTERVAL=30

get_battery_level() {
    if [[ -f "$BATTERY_PATH/capacity" ]]; then
        cat "$BATTERY_PATH/capacity"
    else
        for bat_path in /sys/class/power_supply/BAT*; do
            if [[ -f "$bat_path/capacity" ]]; then
                cat "$bat_path/capacity"
                return
            fi
        done
        echo "0"
    fi
}

get_battery_status() {
    if [[ -f "$BATTERY_PATH/status" ]]; then
        cat "$BATTERY_PATH/status"
    else
        for bat_path in /sys/class/power_supply/BAT*; do
            if [[ -f "$bat_path/status" ]]; then
                cat "$bat_path/status"
                return
            fi
        done
        echo "Unknown"
    fi
}
