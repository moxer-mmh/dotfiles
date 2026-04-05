#!/bin/bash

STATE_FILE="/tmp/nightlight.state"
DEFAULT_TEMP=3000
TEMP_STEP=200
TEMP_MIN=1000
TEMP_MAX=6500

load_state() {
    ENABLED="false"
    TEMPERATURE="$DEFAULT_TEMP"

    if [[ -f "$STATE_FILE" ]]; then
        # shellcheck source=/dev/null
        source "$STATE_FILE" 2>/dev/null || true
    fi
}

save_state() {
    printf 'ENABLED=%s\nTEMPERATURE=%s\n' "$ENABLED" "$TEMPERATURE" > "$STATE_FILE"
}

is_running() {
    pgrep -x wlsunset &>/dev/null
}

start_wlsunset() {
    pkill -x wlsunset 2>/dev/null || true
    sleep 0.2
    # wlsunset requires -T > -t, so set max 1K higher
    wlsunset -t "$TEMPERATURE" -T "$((TEMPERATURE + 1))" &>/dev/null &
    disown
}

stop_wlsunset() {
    pkill -x wlsunset 2>/dev/null || true
}

do_toggle() {
    load_state
    if [[ "$ENABLED" == "true" ]] || is_running; then
        stop_wlsunset
        ENABLED="false"
    else
        ENABLED="true"
        start_wlsunset
    fi
    save_state
}

do_temp_up() {
    load_state
    local new_temp=$(( TEMPERATURE + TEMP_STEP ))
    if (( new_temp > TEMP_MAX )); then
        new_temp=$TEMP_MAX
    fi
    TEMPERATURE="$new_temp"
    save_state
    if [[ "$ENABLED" == "true" ]] || is_running; then
        start_wlsunset
    fi
}

do_temp_down() {
    load_state
    local new_temp=$(( TEMPERATURE - TEMP_STEP ))
    if (( new_temp < TEMP_MIN )); then
        new_temp=$TEMP_MIN
    fi
    TEMPERATURE="$new_temp"
    save_state
    if [[ "$ENABLED" == "true" ]] || is_running; then
        start_wlsunset
    fi
}

do_status() {
    load_state

    # Sync state with actual process status
    if is_running; then
        ENABLED="true"
    fi

    local icon class tooltip
    if [[ "$ENABLED" == "true" ]]; then
        icon="󰌵"
        class="on"
        tooltip="Night Light: ON\nTemperature: ${TEMPERATURE}K"
    else
        icon="󰌶"
        class="off"
        tooltip="Night Light: OFF\nTemperature: ${TEMPERATURE}K"
    fi

    local text="${icon} ${TEMPERATURE}K"
    tooltip="${tooltip//\"/\\\"}"
    tooltip="${tooltip//$'\n'/\\n}"

    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
        "$text" "$class" "$tooltip"
}

ARG="${1:-status}"

case "$ARG" in
    toggle)     do_toggle ;;
    temp-up)    do_temp_up ;;
    temp-down)  do_temp_down ;;
    status|*)   do_status ;;
esac
