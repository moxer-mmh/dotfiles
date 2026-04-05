#!/usr/bin/env bash
# audio-input-switcher.sh — Rofi audio input (source/microphone) switcher for PipeWire/WirePlumber
# Switches default source and moves all existing source-outputs to the selected device.
# Monitor sources (.monitor) are filtered out.

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

get_icon() {
    local desc="${1,,}"  # lowercase

    if [[ "$desc" == *"bluetooth"* ]] || [[ "$desc" == *"bt "* ]]; then
        echo "󰂯"
    elif [[ "$desc" == *"hdmi"* ]]; then
        echo "󰡁"
    elif [[ "$desc" == *"webcam"* ]] || [[ "$desc" == *"camera"* ]]; then
        echo "󰖠"
    elif [[ "$desc" == *"headset"* ]] || [[ "$desc" == *"headphone"* ]]; then
        echo "󰋋"
    else
        echo "󰍬"  # generic microphone
    fi
}

notify() {
    local summary="$1"
    local body="$2"
    local icon="${3:-audio-input-microphone}"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Audio Switcher" -i "$icon" "$summary" "$body"
    fi
}

# --------------------------------------------------------------------------- #
# Build source list: name → description map (exclude .monitor)
# --------------------------------------------------------------------------- #

mapfile -t ALL_SOURCE_NAMES < <(pactl list sources short | awk '{print $2}')

SOURCE_NAMES=()
for name in "${ALL_SOURCE_NAMES[@]}"; do
    # Skip PipeWire/PulseAudio monitor sources
    [[ "$name" == *.monitor ]] && continue
    SOURCE_NAMES+=("$name")
done

if [[ ${#SOURCE_NAMES[@]} -eq 0 ]]; then
    notify "Audio Input" "No audio input devices found." "dialog-error"
    exit 1
fi

declare -A SOURCE_DESC

current_name=""
while IFS= read -r line; do
    if [[ "$line" =~ ^Source\ #[0-9]+ ]]; then
        current_name=""
    elif [[ "$line" =~ ^[[:space:]]*Name:[[:space:]]+(.*) ]]; then
        current_name="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^[[:space:]]*Description:[[:space:]]+(.*) ]]; then
        if [[ -n "$current_name" ]]; then
            SOURCE_DESC["$current_name"]="${BASH_REMATCH[1]}"
        fi
    fi
done < <(pactl list sources)

# Current default source
DEFAULT_SOURCE=$(pactl get-default-source 2>/dev/null)

# --------------------------------------------------------------------------- #
# Build rofi menu entries
# --------------------------------------------------------------------------- #

declare -A ENTRY_TO_NAME
MENU_ENTRIES=()

for name in "${SOURCE_NAMES[@]}"; do
    desc="${SOURCE_DESC[$name]:-$name}"
    icon=$(get_icon "$desc")

    marker=""
    [[ "$name" == "$DEFAULT_SOURCE" ]] && marker=" (active)"

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
         -p "Audio Input" \
         -theme-str 'window {width: 40%;}' \
         -no-custom)

[[ -z "$CHOSEN" ]] && exit 0

SOURCE_NAME="${ENTRY_TO_NAME[$CHOSEN]}"
[[ -z "$SOURCE_NAME" ]] && exit 1

# --------------------------------------------------------------------------- #
# Apply selection
# --------------------------------------------------------------------------- #

# Set new default source
pactl set-default-source "$SOURCE_NAME"

# Move all existing source-outputs to the new source
while IFS= read -r stream_id; do
    [[ -z "$stream_id" ]] && continue
    pactl move-source-output "$stream_id" "$SOURCE_NAME"
done < <(pactl list source-outputs short | awk '{print $1}')

# Notify
desc="${SOURCE_DESC[$SOURCE_NAME]:-$SOURCE_NAME}"
notify "Audio Input" "Switched to: ${desc}" "audio-input-microphone"
