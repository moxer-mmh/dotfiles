#!/bin/bash

CACHE_FILE="$HOME/.cache/waybar-weather"
LOCATION_CACHE="$HOME/.cache/waybar-weather-location"
CACHE_TTL=1800  # 30 minutes in seconds

get_location() {
    local now
    now=$(date +%s)

    if [[ -f "$LOCATION_CACHE" ]]; then
        local cached_time
        cached_time=$(stat -c %Y "$LOCATION_CACHE" 2>/dev/null || echo 0)
        local age=$(( now - cached_time ))
        if (( age < 86400 )); then  # cache location for 24h
            cat "$LOCATION_CACHE"
            return
        fi
    fi

    local city
    city=$(curl -sf --max-time 5 "ipinfo.io/city" 2>/dev/null || echo "")
    if [[ -z "$city" ]]; then
        city="auto"
    fi

    echo "$city" > "$LOCATION_CACHE"
    echo "$city"
}

get_weather_icon() {
    local condition="$1"
    case "${condition,,}" in
        *thunder*|*storm*)           echo "󰖓" ;;
        *snow*|*blizzard*|*sleet*)   echo "󰖘" ;;
        *rain*|*drizzle*|*shower*)   echo "󰖗" ;;
        *fog*|*mist*|*haze*)         echo "󰖑" ;;
        *cloud*|*overcast*)          echo "󰖐" ;;
        *clear*|*sunny*)             echo "󰖙" ;;
        *)                           echo "󰖙" ;;
    esac
}

output_error() {
    printf '{"text": "󰖙 N/A", "class": "error", "tooltip": "Weather unavailable"}\n'
}

main() {
    local now
    now=$(date +%s)

    # Check cache
    if [[ -f "$CACHE_FILE" ]]; then
        local cached_time
        cached_time=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
        local age=$(( now - cached_time ))
        if (( age < CACHE_TTL )); then
            cat "$CACHE_FILE"
            return
        fi
    fi

    local location
    location=$(get_location)

    local raw
    raw=$(curl -sf --max-time 10 "wttr.in/${location}?format=j1" 2>/dev/null || echo "")

    if [[ -z "$raw" ]]; then
        output_error
        return
    fi

    local temp condition humidity wind_speed wind_dir city_name

    temp=$(echo "$raw" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['current_condition'][0]['temp_C'])
" 2>/dev/null || echo "")

    condition=$(echo "$raw" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['current_condition'][0]['weatherDesc'][0]['value'])
" 2>/dev/null || echo "")

    humidity=$(echo "$raw" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['current_condition'][0]['humidity'])
" 2>/dev/null || echo "")

    wind_speed=$(echo "$raw" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['current_condition'][0]['windspeedKmph'])
" 2>/dev/null || echo "")

    wind_dir=$(echo "$raw" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['current_condition'][0]['winddir16Point'])
" 2>/dev/null || echo "")

    city_name=$(echo "$raw" | python3 -c "
import sys, json
d = json.load(sys.stdin)
area = d.get('nearest_area', [{}])[0]
city = area.get('areaName', [{}])[0].get('value', '')
country = area.get('country', [{}])[0].get('value', '')
print(f'{city}, {country}' if city else 'Unknown')
" 2>/dev/null || echo "$location")

    if [[ -z "$temp" || -z "$condition" ]]; then
        output_error
        return
    fi

    local icon
    icon=$(get_weather_icon "$condition")

    # Escape strings for JSON
    condition_escaped="${condition//\"/\\\"}"
    city_escaped="${city_name//\"/\\\"}"
    wind_dir_escaped="${wind_dir//\"/\\\"}"

    local tooltip="Location: ${city_escaped}\nCondition: ${condition_escaped}\nHumidity: ${humidity}%\nWind: ${wind_speed} km/h ${wind_dir_escaped}"
    local result
    result=$(printf '{"text": "%s %s°C", "class": "weather", "tooltip": "%s"}' \
        "$icon" "$temp" "$tooltip")

    echo "$result" > "$CACHE_FILE"
    echo "$result"
}

main
