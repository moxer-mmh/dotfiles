#!/usr/bin/env bash
# keybind-hints.sh — Show keybind reference via rofi
# Part of the Hyprland Space Station setup
#
# Parses ~/.config/hypr/conf.d/keybinds.conf, formats each bind as
# "MOD + KEY → ACTION", presents them in rofi -dmenu, and executes
# the selected action.

KEYBINDS_FILE="${HOME}/.config/hypr/conf.d/keybinds.conf"

if [[ ! -f "$KEYBINDS_FILE" ]]; then
    notify-send -u critical "Keybind Hints" "keybinds.conf not found at $KEYBINDS_FILE"
    exit 1
fi

if ! command -v rofi &>/dev/null; then
    notify-send -u critical "Keybind Hints" "rofi is not installed."
    exit 1
fi

# ---------------------------------------------------------------------------
# Parse keybinds.conf
# ---------------------------------------------------------------------------
# Resolve $mainMod variable (default to SUPER if not found)
MAINMOD=$(grep -m1 '^\$mainMod\s*=' "$KEYBINDS_FILE" | sed 's/.*=\s*//' | tr -d '[:space:]')
MAINMOD="${MAINMOD:-SUPER}"

declare -a DISPLAY_LINES   # human-readable labels shown in rofi
declare -a EXEC_COMMANDS   # corresponding exec commands (for exec dispatches)
declare -a DISPATCH_TYPES  # dispatcher type for non-exec binds

# Section tracker — updated when a comment section header is encountered
current_section="General"

while IFS= read -r line; do
    # Track section comments (lines like: # ── Section Name ──)
    if [[ "$line" =~ ^#[[:space:]]*──[[:space:]]*(.*)[[:space:]]*── ]]; then
        raw_section="${BASH_REMATCH[1]}"
        # Strip trailing dashes/spaces
        current_section=$(echo "$raw_section" | sed 's/[[:space:]]*[-─]*[[:space:]]*$//' | sed 's/^[[:space:]]*//')
        continue
    fi

    # Skip comments and blanks
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// /}" ]] && continue

    # Match: bind[el|l|m] = MODS, KEY, dispatcher[, args]
    if [[ "$line" =~ ^bind[a-z]*[[:space:]]*=[[:space:]]*([^,]*)[[:space:]]*,[[:space:]]*([^,]+)[[:space:]]*,[[:space:]]*([^,]+)[[:space:]]*,?(.*) ]]; then
        raw_mods="${BASH_REMATCH[1]}"
        raw_key="${BASH_REMATCH[2]}"
        dispatcher="${BASH_REMATCH[3]}"
        disp_args="${BASH_REMATCH[4]}"

        # Substitute $mainMod
        mods="${raw_mods/\$mainMod/$MAINMOD}"

        # Normalise modifier string: trim, uppercase, collapse spaces
        mods=$(echo "$mods" | tr '[:lower:]' '[:upper:]' | sed 's/[[:space:]]\+/ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        key=$(echo "$raw_key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        dispatcher=$(echo "$dispatcher" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        disp_args=$(echo "$disp_args" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Skip mouse binds — not useful as hints
        [[ "$key" =~ ^mouse: ]] && continue
        # Skip XF86 / media/brightness keys (too long, not user-memorable)
        [[ "$key" =~ ^XF86 ]] && continue

        # Build the mod+key label
        if [[ -n "$mods" ]]; then
            mod_label="${mods} + ${key^^}"
        else
            mod_label="${key^^}"
        fi

        # Build the action label
        if [[ "$dispatcher" == "exec" ]]; then
            # Show the command basename with first argument for brevity
            cmd_base=$(echo "$disp_args" | awk '{print $1}')
            cmd_base=$(basename "$cmd_base")
            action_label="exec: ${cmd_base}"
            exec_cmd="$disp_args"
        else
            # Non-exec dispatcher: show dispatcher + args
            if [[ -n "$disp_args" ]]; then
                action_label="${dispatcher}: ${disp_args}"
            else
                action_label="${dispatcher}"
            fi
            exec_cmd=""
        fi

        display="[${current_section}]  ${mod_label}  →  ${action_label}"

        DISPLAY_LINES+=("$display")
        EXEC_COMMANDS+=("$exec_cmd")
        DISPATCH_TYPES+=("$dispatcher|$disp_args")
    fi
done < "$KEYBINDS_FILE"

if [[ ${#DISPLAY_LINES[@]} -eq 0 ]]; then
    notify-send "Keybind Hints" "No keybinds found in $KEYBINDS_FILE"
    exit 0
fi

# ---------------------------------------------------------------------------
# Present in rofi
# ---------------------------------------------------------------------------
printf '%s\n' "${DISPLAY_LINES[@]}" | \
    rofi -dmenu \
        -i \
        -p "Keybinds" \
        -theme-str 'window {width: 900px;}' \
        -theme-str 'listview {lines: 18;}' \
        -font "monospace 11" \
        -no-custom \
    > /tmp/keybind_selection.tmp 2>/dev/null

selected=$(cat /tmp/keybind_selection.tmp 2>/dev/null)
rm -f /tmp/keybind_selection.tmp

[[ -z "$selected" ]] && exit 0

# ---------------------------------------------------------------------------
# Find and execute the selected entry
# ---------------------------------------------------------------------------
for i in "${!DISPLAY_LINES[@]}"; do
    if [[ "${DISPLAY_LINES[$i]}" == "$selected" ]]; then
        exec_cmd="${EXEC_COMMANDS[$i]}"
        dispatch_info="${DISPATCH_TYPES[$i]}"

        if [[ -n "$exec_cmd" ]]; then
            # Execute the command via bash to expand ~ and handle args
            bash -c "$exec_cmd" &
            disown
        else
            # Non-exec dispatcher: use hyprctl
            dispatcher="${dispatch_info%%|*}"
            disp_args="${dispatch_info#*|}"
            if [[ -n "$disp_args" ]]; then
                hyprctl dispatch "$dispatcher" "$disp_args"
            else
                hyprctl dispatch "$dispatcher"
            fi
        fi
        break
    fi
done
