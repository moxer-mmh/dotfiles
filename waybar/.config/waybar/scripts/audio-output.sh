#!/usr/bin/env bash

# Detect an appropriate icon based on sink name/description
get_sink_icon() {
    local name="${1,,}"  # lowercase

    if [[ "$name" == *"bluetooth"* ]] || [[ "$name" == *"bluez"* ]]; then
        echo "󰂯"
    elif [[ "$name" == *"hdmi"* ]] || [[ "$name" == *"dp"* ]] || [[ "$name" == *"displayport"* ]]; then
        echo "󰡁"
    elif [[ "$name" == *"headphone"* ]] || [[ "$name" == *"headset"* ]] || \
         [[ "$name" == *"earphone"* ]] || [[ "$name" == *"analog-stereo"* && "$name" == *"front"* ]]; then
        echo "󰋋"
    else
        echo "󰓃"
    fi
}

# Return a shortened, human-readable sink label
get_sink_label() {
    local name="$1"

    # Strip long PipeWire/PulseAudio prefixes
    local short
    short=$(echo "$name" \
        | sed 's/alsa_output\.//' \
        | sed 's/bluez_output\.//' \
        | sed 's/\.monitor$//' \
        | sed 's/_/-/g' \
        | cut -c1-30)

    echo "$short"
}

cmd_status() {
    # wpctl gives us the default sink description
    local sink_info
    sink_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    if [[ -z "$sink_info" ]]; then
        printf '{"text": "󰓃 N/A", "class": "active", "tooltip": "No audio sink found"}\n'
        return
    fi

    # Get the default sink name via pactl for icon detection
    local default_sink
    default_sink=$(pactl get-default-sink 2>/dev/null)

    local icon
    icon=$(get_sink_icon "$default_sink")

    local label
    label=$(get_sink_label "$default_sink")

    local tooltip="Current output: $default_sink"

    printf '{"text": "%s %s", "class": "active", "tooltip": "%s"}\n' \
        "$icon" "$label" "$tooltip"
}

cmd_switch() {
    # Build a list of available sinks: "INDEX NAME DESCRIPTION"
    local sinks_raw
    sinks_raw=$(pactl list sinks short 2>/dev/null)

    if [[ -z "$sinks_raw" ]]; then
        notify-send "Audio Output" "No sinks available." -t 3000
        exit 1
    fi

    # Build display entries pairing icon+description with internal name
    declare -a display_entries
    declare -A name_map   # display -> internal name

    while IFS=$'\t' read -r index name driver format rate state; do
        # Fetch the description for this sink
        local desc
        desc=$(pactl list sinks 2>/dev/null \
            | awk "/^Sink #${index}$/,/^Sink #/" \
            | grep -m1 'device.description' \
            | sed 's/.*= "\(.*\)"/\1/')

        [[ -z "$desc" ]] && desc="$name"

        local icon
        icon=$(get_sink_icon "$name $desc")
        local entry="${icon} ${desc}"

        display_entries+=("$entry")
        name_map["$entry"]="$name"
    done <<< "$sinks_raw"

    if [[ ${#display_entries[@]} -eq 0 ]]; then
        notify-send "Audio Output" "No sinks available." -t 3000
        exit 1
    fi

    local choice
    choice=$(printf '%s\n' "${display_entries[@]}" \
        | rofi -dmenu \
               -p "Audio Output" \
               -theme-str 'window {width: 500px;}' \
               -no-fixed-num-lines)

    [[ -z "$choice" ]] && exit 0

    local selected_sink="${name_map[$choice]}"
    if [[ -z "$selected_sink" ]]; then
        notify-send "Audio Output" "Could not resolve sink." -t 3000
        exit 1
    fi

    # Set the new default sink
    pactl set-default-sink "$selected_sink"

    # Move all existing playback streams to the new sink
    while read -r stream_index; do
        pactl move-sink-input "$stream_index" "$selected_sink" 2>/dev/null
    done < <(pactl list sink-inputs short 2>/dev/null | awk '{print $1}')

    notify-send "Audio Output" "Switched to: $choice" -t 3000
}

case "$1" in
    status) cmd_status ;;
    switch) cmd_switch ;;
    *)
        echo "Usage: $0 {status|switch}" >&2
        exit 1
        ;;
esac
