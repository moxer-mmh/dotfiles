#!/bin/bash
set -euo pipefail

CRITICAL_TEMP=80

find_hwmon_sensor() {
    local hwmon_dir="/sys/class/hwmon"

    if [[ ! -d "$hwmon_dir" ]]; then
        return 1
    fi

    # Search for coretemp (Intel) or k10temp (AMD)
    for name_file in "$hwmon_dir"/*/name; do
        [[ -f "$name_file" ]] || continue
        local sensor_name
        sensor_name=$(cat "$name_file" 2>/dev/null || true)
        case "$sensor_name" in
            coretemp|k10temp)
                local hwmon_path
                hwmon_path=$(dirname "$name_file")
                # Find the first temp*_input file
                for temp_file in "$hwmon_path"/temp*_input; do
                    [[ -f "$temp_file" ]] || continue
                    local raw
                    raw=$(cat "$temp_file" 2>/dev/null || true)
                    if [[ "$raw" =~ ^[0-9]+$ ]]; then
                        echo "$hwmon_path:$sensor_name:$temp_file"
                        return 0
                    fi
                done
                ;;
        esac
    done

    return 1
}

find_thermal_zone() {
    local zone_dir="/sys/class/thermal"

    if [[ ! -d "$zone_dir" ]]; then
        return 1
    fi

    for zone in "$zone_dir"/thermal_zone*; do
        [[ -d "$zone" ]] || continue
        local type_file="$zone/type"
        local temp_file="$zone/temp"
        [[ -f "$temp_file" ]] || continue

        local raw
        raw=$(cat "$temp_file" 2>/dev/null || true)
        if [[ "$raw" =~ ^[0-9]+$ ]] && (( raw > 0 )); then
            local zone_type="unknown"
            [[ -f "$type_file" ]] && zone_type=$(cat "$type_file" 2>/dev/null || echo "unknown")
            echo "$zone:$zone_type:$temp_file"
            return 0
        fi
    done

    return 1
}

read_temp_millidegrees() {
    local temp_file="$1"
    cat "$temp_file" 2>/dev/null || echo "0"
}

main() {
    local sensor_label="unknown"
    local temp_raw=0
    local found=false

    # Try hwmon first (more accurate, covers coretemp/k10temp)
    local hwmon_result=""
    if hwmon_result=$(find_hwmon_sensor 2>/dev/null); then
        local hwmon_path sensor_name temp_file
        IFS=':' read -r hwmon_path sensor_name temp_file <<< "$hwmon_result"
        temp_raw=$(read_temp_millidegrees "$temp_file")
        sensor_label="$sensor_name"
        found=true
    fi

    # Fallback to thermal_zone
    if [[ "$found" == "false" ]]; then
        local zone_result=""
        if zone_result=$(find_thermal_zone 2>/dev/null); then
            local zone_path zone_type temp_file
            IFS=':' read -r zone_path zone_type temp_file <<< "$zone_result"
            temp_raw=$(read_temp_millidegrees "$temp_file")
            sensor_label="$zone_type"
            found=true
        fi
    fi

    if [[ "$found" == "false" ]]; then
        printf '{"text": "󰔏 N/A", "class": "normal", "tooltip": "No temperature sensor found"}\n'
        return
    fi

    # Convert millidegrees to degrees
    local temp_c=$(( temp_raw / 1000 ))

    local class="normal"
    if (( temp_c >= CRITICAL_TEMP )); then
        class="critical"
    fi

    sensor_label="${sensor_label//\"/\\\"}"

    printf '{"text": "󰔏 %d°C", "class": "%s", "tooltip": "Sensor: %s\nTemperature: %d°C"}\n' \
        "$temp_c" "$class" "$sensor_label" "$temp_c"
}

main
