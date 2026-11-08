#!/usr/bin/env bash
# keybind-hints.sh — Show keybind reference via rofi
# Part of the Hyprland Space Station setup
#
# Reads the binds Hyprland has actually loaded (`hyprctl binds -j`), formats
# each one as "[Section]  MODS + KEY  →  description", shows them in rofi, and
# runs the one you pick.
#
# Descriptions come from modules/keybinds.lua. Running a pick goes through the
# SPACE_STATION_BINDS table that module fills: description -> dispatcher.
# Mouse binds, media keys and draw-mode (submap) binds are left out.

set -uo pipefail

for cmd in rofi jq hyprctl; do
    if ! command -v "$cmd" &>/dev/null; then
        notify-send -u critical "Keybind Hints" "$cmd is not installed."
        exit 1
    fi
done

if ! binds_json=$(hyprctl binds -j 2>/dev/null) || [[ -z "$binds_json" ]]; then
    notify-send -u critical "Keybind Hints" "Could not read binds from Hyprland."
    exit 1
fi

# One line per bind: "<description>\t<label>". The description is the lookup
# key for SPACE_STATION_BINDS; the label is what rofi shows.
# modmask bits (wlroots): SHIFT 1, CAPS 2, CTRL 4, ALT 8, MOD2 16, MOD3 32,
# SUPER 64, MOD5 128. Only the four that matter for display are decoded.
mapfile -t ENTRIES < <(jq -r '
    def mods:
        [ (if (.modmask / 64 | floor) % 2 == 1 then "SUPER" else empty end),
          (if (.modmask / 4  | floor) % 2 == 1 then "CTRL"  else empty end),
          (if (.modmask / 8  | floor) % 2 == 1 then "ALT"   else empty end),
          (if  .modmask % 2 == 1                then "SHIFT" else empty end) ];
    .[]
    | select(.has_description and .submap == "" and (.mouse | not))
    | select(.key | test("^XF86") | not)
    | (.description | capture("^\\[(?<section>[^\\]]+)\\] (?<text>.*)$")) as $d
    | ((mods + [.key | ascii_upcase]) | join(" + ")) as $combo
    | "\(.description)\t[\($d.section)]  \($combo)  →  \($d.text)"
' <<<"$binds_json")

if (( ${#ENTRIES[@]} == 0 )); then
    notify-send "Keybind Hints" "No described keybinds are loaded."
    exit 0
fi

selected=$(printf '%s\n' "${ENTRIES[@]}" | cut -f2 | \
    rofi -dmenu \
        -i \
        -p "Keybinds" \
        -theme-str 'window {width: 900px;}' \
        -theme-str 'listview {lines: 18;}' \
        -font "monospace 11" \
        -no-custom 2>/dev/null) || exit 0

[[ -z "$selected" ]] && exit 0

for entry in "${ENTRIES[@]}"; do
    if [[ "${entry#*$'\t'}" == "$selected" ]]; then
        desc="${entry%%$'\t'*}"
        # Lua long-bracket string: no escaping needed for anything in desc.
        hyprctl eval "hl.dispatch(SPACE_STATION_BINDS[ [==[$desc]==] ])" >/dev/null
        break
    fi
done
