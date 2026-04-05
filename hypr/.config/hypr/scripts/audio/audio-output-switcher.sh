#!/usr/bin/env bash
# audio-output-switcher.sh — Rofi audio output (sink) switcher for PipeWire/WirePlumber
# Switches default sink and moves all existing streams to the selected device.

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

get_icon() {
    local desc="${1,,}"  # lowercase

    if [[ "$desc" == *"bluetooth"* ]] || [[ "$desc" == *"bt "* ]]; then
        echo "󰂯"
    elif [[ "$desc" == *"hdmi"* ]] || [[ "$desc" == *"dp"* ]] || [[ "$desc" == *"displayport"* ]]; then
        echo "󰡁"
    elif [[ "$desc" == *"headphone"* ]] || [[ "$desc" == *"headset"* ]] || \
         [[ "$desc" == *"earphone"* ]] || [[ "$desc" == *"earpiece"* ]]; then
        echo "󰋋"
    else
        echo "󰓃"
    fi
}

notify() {
    local summary="$1"
    local body="$2"
    local icon="${3:-audio-speakers}"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Audio Switcher" -i "$icon" "$summary" "$body"
    fi
}

# --------------------------------------------------------------------------- #
# Build sink list: name → description map
# --------------------------------------------------------------------------- #

# Collect sink names in order
mapfile -t SINK_NAMES < <(pactl list sinks short | awk '{print $2}')

if [[ ${#SINK_NAMES[@]} -eq 0 ]]; then
    notify "Audio Switcher" "No audio output devices found." "dialog-error"
    exit 1
fi

# Build associative array: sink_name → description
declare -A SINK_DESC

current_name=""
while IFS= read -r line; do
    if [[ "$line" =~ ^Sink\ #[0-9]+ ]]; then
        current_name=""
    elif [[ "$line" =~ ^[[:space:]]*Name:[[:space:]]+(.*) ]]; then
        current_name="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^[[:space:]]*Description:[[:space:]]+(.*) ]]; then
        if [[ -n "$current_name" ]]; then
            SINK_DESC["$current_name"]="${BASH_REMATCH[1]}"
        fi
    fi
done < <(pactl list sinks)

# Current default sink
DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null)

# --------------------------------------------------------------------------- #
# Build rofi menu entries
# --------------------------------------------------------------------------- #

declare -A ENTRY_TO_NAME
MENU_ENTRIES=()

for name in "${SINK_NAMES[@]}"; do
    desc="${SINK_DESC[$name]:-$name}"
    icon=$(get_icon "$desc")

    marker=""
    [[ "$name" == "$DEFAULT_SINK" ]] && marker=" (active)"

    entry="${icon}  ${desc}${marker}"
    ENTRY_TO_NAME["$entry"]="$name"
    MENU_ENTRIES+=("$entry")
done

# --------------------------------------------------------------------------- #
# Show rofi
# --------------------------------------------------------------------------- #

CHOSEN=$(printf '%s\n' "${MENU_ENTRIES[@]}" | \
    rofi -dmenu \
         -i \
         -p "Audio Output" \
         -theme-str 'window {width: 40%;}' \
         -no-custom)

[[ -z "$CHOSEN" ]] && exit 0

SINK_NAME="${ENTRY_TO_NAME[$CHOSEN]}"
[[ -z "$SINK_NAME" ]] && exit 1

# --------------------------------------------------------------------------- #
# Apply selection
# --------------------------------------------------------------------------- #

# Set new default sink
pactl set-default-sink "$SINK_NAME"

# Move all existing sink-inputs to the new sink
while IFS= read -r stream_id; do
    [[ -z "$stream_id" ]] && continue
    pactl move-sink-input "$stream_id" "$SINK_NAME"
done < <(pactl list sink-inputs short | awk '{print $1}')

# Notify
desc="${SINK_DESC[$SINK_NAME]:-$SINK_NAME}"
icon_name="audio-speakers"
desc_lower="${desc,,}"
if [[ "$desc_lower" == *"headphone"* ]] || [[ "$desc_lower" == *"headset"* ]]; then
    icon_name="audio-headphones"
elif [[ "$desc_lower" == *"bluetooth"* ]]; then
    icon_name="bluetooth-active"
fi

notify "Audio Output" "Switched to: ${desc}" "$icon_name"
