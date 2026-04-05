#!/usr/bin/env bash
# volume-boost.sh — Set volume above 100% using wpctl (PipeWire/WirePlumber)
#
# Usage:
#   volume-boost.sh set <percent>   — set volume to <percent> (e.g., 150)
#   volume-boost.sh status          — print current volume info as JSON

WARN_THRESHOLD=120  # percent — warn if above this

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

notify() {
    local urgency="${1:-normal}"
    local summary="$2"
    local body="$3"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Volume" -u "$urgency" -i "audio-volume-high" "$summary" "$body"
    fi
}

# Returns raw volume as a float (e.g., "1.00" or "1.50")
get_raw_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2}'
}

# Returns volume as integer percent (e.g., 100, 150)
get_volume_percent() {
    local raw
    raw=$(get_raw_volume)
    if [[ -z "$raw" ]]; then
        echo "0"
        return
    fi
    # Multiply by 100, round to nearest integer
    printf "%.0f" "$(echo "$raw * 100" | bc -l 2>/dev/null || awk "BEGIN{printf \"%.0f\", $raw * 100}")"
}

is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q '\[MUTED\]'
}

print_status() {
    local pct
    pct=$(get_volume_percent)
    local muted="false"
    is_muted && muted="true"

    local boosted="false"
    (( pct > 100 )) && boosted="true"

    local icon
    if [[ "$muted" == "true" ]]; then
        icon="󰝟"
    elif (( pct == 0 )); then
        icon="󰕿"
    elif (( pct <= 33 )); then
        icon="󰖀"
    elif (( pct <= 66 )); then
        icon="󰕾"
    elif (( pct <= 100 )); then
        icon="󰕾"
    else
        icon="󰗎"  # boosted
    fi

    printf '{"text": "%s %d%%", "tooltip": "Volume: %d%%%s", "class": "%s", "percentage": %d}\n' \
        "$icon" \
        "$pct" \
        "$pct" \
        "$(is_muted && echo ' [MUTED]' || echo '')" \
        "$(if [[ "$muted" == "true" ]]; then echo "muted"; elif [[ "$boosted" == "true" ]]; then echo "boosted"; else echo "normal"; fi)" \
        "$pct"
}

do_set() {
    local percent="$1"

    # Validate input
    if ! [[ "$percent" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: percent must be a positive number (e.g., 150)" >&2
        exit 1
    fi

    if (( $(echo "$percent <= 0" | bc -l) )); then
        echo "Error: percent must be greater than 0" >&2
        exit 1
    fi

    # Convert percent to wpctl value (e.g., 150 → 1.5)
    local value
    value=$(awk "BEGIN{printf \"%.4f\", $percent / 100}")

    # Apply volume — wpctl accepts values above 1.0 without extra flags
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$value"

    local int_pct
    int_pct=$(printf "%.0f" "$percent")

    if (( int_pct > WARN_THRESHOLD )); then
        notify "critical" \
            "Volume Warning" \
            "Volume set to ${int_pct}% — high levels may damage hearing or speakers!"
    else
        notify "normal" \
            "Volume" \
            "Volume set to ${int_pct}%"
    fi
}

# --------------------------------------------------------------------------- #
# Entrypoint
# --------------------------------------------------------------------------- #

ACTION="${1:-status}"

case "$ACTION" in
    set)
        if [[ -z "$2" ]]; then
            echo "Usage: $(basename "$0") set <percent>" >&2
            exit 1
        fi
        do_set "$2"
        ;;
    status)
        print_status
        ;;
    *)
        echo "Usage: $(basename "$0") [set <percent>|status]" >&2
        exit 1
        ;;
esac
