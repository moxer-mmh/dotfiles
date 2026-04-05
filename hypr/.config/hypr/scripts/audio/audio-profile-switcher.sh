#!/usr/bin/env bash
# audio-profile-switcher.sh — Rofi card profile switcher for PipeWire/WirePlumber
# Lists all cards and their available profiles; lets the user pick one.

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #

get_profile_icon() {
    local profile="${1,,}"

    if [[ "$profile" == *"a2dp"* ]] || [[ "$profile" == *"bluetooth"* ]]; then
        echo "󰂯"
    elif [[ "$profile" == *"hdmi"* ]] || [[ "$profile" == *"iec958"* ]] || \
         [[ "$profile" == *"spdif"* ]]; then
        echo "󰡁"
    elif [[ "$profile" == *"headphone"* ]] || [[ "$profile" == *"headset"* ]]; then
        echo "󰋋"
    elif [[ "$profile" == *"surround"* ]] || [[ "$profile" == *"5.1"* ]] || \
         [[ "$profile" == *"7.1"* ]]; then
        echo "󰓃"
    elif [[ "$profile" == *"hfp"* ]] || [[ "$profile" == *"hsp"* ]]; then
        echo "󰋍"  # headset/phone profile
    elif [[ "$profile" == *"off"* ]]; then
        echo "󰓄"  # muted/off
    else
        echo "󰓃"  # default speaker
    fi
}

notify() {
    local summary="$1"
    local body="$2"
    local icon="${3:-audio-speakers}"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Audio Profile" -i "$icon" "$summary" "$body"
    fi
}

# --------------------------------------------------------------------------- #
# Parse cards and profiles from `pactl list cards`
# --------------------------------------------------------------------------- #

# Data is stored as parallel arrays:
#   CARD_IDS[i]          — numeric card id (for pactl set-card-profile)
#   CARD_NAMES[i]        — internal card name
#   CARD_DESCS[i]        — human-readable description
#   PROFILE_CARD_IDX[j]  — which card this profile belongs to (index into above)
#   PROFILE_NAMES[j]     — profile name (used with pactl set-card-profile)
#   PROFILE_DESCS[j]     — profile description
#   PROFILE_ACTIVE[j]    — "yes" if this is the active profile on that card

CARD_IDS=()
CARD_NAMES=()
CARD_DESCS=()
PROFILE_CARD_IDX=()
PROFILE_NAMES=()
PROFILE_DESCS=()
PROFILE_ACTIVE=()

current_card_idx=-1
current_card_id=""
current_card_name=""
current_card_desc=""
active_profile=""
in_profiles_section=false

while IFS= read -r line; do
    # New card block
    if [[ "$line" =~ ^Card\ #([0-9]+) ]]; then
        current_card_id="${BASH_REMATCH[1]}"
        current_card_name=""
        current_card_desc=""
        active_profile=""
        in_profiles_section=false
        continue
    fi

    if [[ "$line" =~ ^[[:space:]]*Name:[[:space:]]+(.*) ]]; then
        current_card_name="${BASH_REMATCH[1]}"
        continue
    fi

    if [[ "$line" =~ ^[[:space:]]*alsa\.card_name[[:space:]]*=[[:space:]]*\"(.*)\" ]] || \
       [[ "$line" =~ ^[[:space:]]*device\.description[[:space:]]*=[[:space:]]*\"(.*)\" ]]; then
        # Prefer device.description; only set if not already set
        [[ -z "$current_card_desc" ]] && current_card_desc="${BASH_REMATCH[1]}"
        continue
    fi

    if [[ "$line" =~ ^[[:space:]]*Active\ Profile:[[:space:]]+(.*) ]]; then
        active_profile="${BASH_REMATCH[1]}"
        continue
    fi

    # Detect start of Profiles section
    if [[ "$line" =~ ^[[:space:]]*Profiles: ]]; then
        # Register card before processing its profiles
        CARD_IDS+=("$current_card_id")
        CARD_NAMES+=("$current_card_name")
        CARD_DESCS+=("${current_card_desc:-$current_card_name}")
        current_card_idx=$(( ${#CARD_IDS[@]} - 1 ))
        in_profiles_section=true
        continue
    fi

    # Inside Profiles section: lines look like:
    #   \t\tprofile-name: Profile Description (sinks: N, sources: M, priority: P, available: yes)
    if [[ "$in_profiles_section" == true ]]; then
        # Detect end of Profiles section (next top-level key)
        if [[ "$line" =~ ^[[:space:]]{1,4}[A-Z] ]] && \
           ! [[ "$line" =~ ^[[:space:]]{5,} ]]; then
            in_profiles_section=false
            continue
        fi

        # Match profile entries (two leading tabs or 8 spaces)
        if [[ "$line" =~ ^[[:space:]]+(([^:[:space:]][^:]*):[[:space:]]+(.*)) ]]; then
            p_name="${BASH_REMATCH[2]}"
            p_rest="${BASH_REMATCH[3]}"

            # Strip trailing parenthetical metadata
            p_desc="${p_rest% (*}"

            # Skip "off" profile? Keep it — user may want to disable a card.
            PROFILE_CARD_IDX+=("$current_card_idx")
            PROFILE_NAMES+=("$p_name")
            PROFILE_DESCS+=("$p_desc")

            if [[ "$p_name" == "$active_profile" ]]; then
                PROFILE_ACTIVE+=("yes")
            else
                PROFILE_ACTIVE+=("no")
            fi
        fi
    fi
done < <(pactl list cards)

if [[ ${#PROFILE_NAMES[@]} -eq 0 ]]; then
    notify "Audio Profile" "No card profiles found." "dialog-error"
    exit 1
fi

# --------------------------------------------------------------------------- #
# Build rofi menu entries
# --------------------------------------------------------------------------- #

declare -A ENTRY_TO_IDX
MENU_ENTRIES=()

for i in "${!PROFILE_NAMES[@]}"; do
    card_idx="${PROFILE_CARD_IDX[$i]}"
    card_desc="${CARD_DESCS[$card_idx]}"
    p_name="${PROFILE_NAMES[$i]}"
    p_desc="${PROFILE_DESCS[$i]}"
    is_active="${PROFILE_ACTIVE[$i]}"

    icon=$(get_profile_icon "$p_name $p_desc")
    marker=""
    [[ "$is_active" == "yes" ]] && marker=" (active)"

    entry="${icon}  [${card_desc}] ${p_desc}${marker}"
    ENTRY_TO_IDX["$entry"]="$i"
    MENU_ENTRIES+=("$entry")
done

# --------------------------------------------------------------------------- #
# Show rofi
# --------------------------------------------------------------------------- #

CHOSEN=$(printf '%s\n' "${MENU_ENTRIES[@]}" | \
    rofi -dmenu \
         -i \
         -p "Audio Profile" \
         -theme-str 'window {width: 50%;}' \
         -no-custom)

[[ -z "$CHOSEN" ]] && exit 0

ENTRY_IDX="${ENTRY_TO_IDX[$CHOSEN]}"
[[ -z "$ENTRY_IDX" ]] && exit 1

CARD_IDX="${PROFILE_CARD_IDX[$ENTRY_IDX]}"
CARD_NAME="${CARD_NAMES[$CARD_IDX]}"
CARD_DESC="${CARD_DESCS[$CARD_IDX]}"
PROFILE_NAME="${PROFILE_NAMES[$ENTRY_IDX]}"
PROFILE_DESC="${PROFILE_DESCS[$ENTRY_IDX]}"

# --------------------------------------------------------------------------- #
# Apply selection
# --------------------------------------------------------------------------- #

pactl set-card-profile "$CARD_NAME" "$PROFILE_NAME"

notify "Audio Profile" "${CARD_DESC}: ${PROFILE_DESC}" "audio-speakers"
