#!/bin/bash
# Audio dropdown — vim keys: j/k navigate, l/Enter select, q/Esc close

vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%d", $2*100}')
mic=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{printf "%d", $2*100}')
sink=$(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep "node.description" | cut -d'"' -f2 | head -1)

[[ $(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) == *MUTED* ]] && mute="MUTED" || mute="${vol}%"
[[ $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null) == *MUTED* ]] && mic_st="MUTED" || mic_st="${mic}%"

ch=$(pactl list sinks 2>/dev/null | grep "Channel Map" | head -1)
[[ "$ch" == *mono* ]] && ch_mode="Mono" || ch_mode="Stereo"

declare -A actions
idx=0
add() { options+=("$1"); actions[$idx]="$2"; ((idx++)); }

options=()
add "󰕾  Volume: $mute"            "pavucontrol"
add "󰍬  Mic: $mic_st"             "pavucontrol --tab=4"
add "󰓃  Output: ${sink:-Unknown}" "noop"
add "󰎆  Mode: $ch_mode"           "noop"
add "─────────────"                "noop"
add "󰝝  Vol +10"                   "vol-up"
add "󰝞  Vol -10"                   "vol-down"
add "󰝟  Mute Speaker"             "mute-sink"
add "󰍭  Mute Mic"                 "mute-source"
add "󰜟  Switch Device"            "switch-device"
add "󰎈  Stereo/Mono"              "stereo-mono"
add "󰓃  Open Mixer"               "mixer"

choice_idx=$(printf '%s\n' "${options[@]}" | rofi -dmenu -theme ~/.config/rofi/dropdown.rasi -p "󰕾 Audio" -mesg "j/k nav · l select · q close" -format i)

[[ -z "$choice_idx" ]] && exit 0
action="${actions[$choice_idx]}"

case "$action" in
    vol-up)        wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+ ;;
    vol-down)      wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%- ;;
    mute-sink)     wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    mute-source)   wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    switch-device) ~/.config/hypr/scripts/audio/audio-output-switcher.sh ;;
    stereo-mono)   ~/.config/hypr/scripts/audio/stereo-mono-toggle.sh toggle ;;
    mixer)         pavucontrol & ;;
    pavucontrol*)  $action & ;;
esac
