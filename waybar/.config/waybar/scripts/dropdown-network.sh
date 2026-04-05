#!/bin/bash
# Network dropdown — vim keys: j/k navigate, l/Enter select, q/Esc close

wifi_ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
wifi_signal=$(nmcli -t -f active,signal dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
wifi_ip=$(ip -4 addr show 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v 127.0.0.1 | head -1)

[[ -n "$wifi_ssid" ]] && wifi="${wifi_ssid} (${wifi_signal}%)" || wifi="Disconnected"

if command -v bluetoothctl &>/dev/null; then
    bt_power=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
    bt_dev=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
    if [[ "$bt_power" == "yes" ]]; then
        [[ -n "$bt_dev" ]] && bt="$bt_dev" || bt="On · no devices"
    else
        bt="Off"
    fi
else
    bt="N/A"
fi

vpn=$(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | grep vpn | cut -d: -f1)
[[ -n "$vpn" ]] && vpn_str="$vpn" || vpn_str="Off"

updates=$(checkupdates 2>/dev/null | wc -l)
aur=$(paru -Qua 2>/dev/null | wc -l)
total=$((updates + aur))

declare -A actions
idx=0
add() { options+=("$1"); actions[$idx]="$2"; ((idx++)); }

options=()
add "󰤨  WiFi: $wifi"              "noop"
add "󰂯  Bluetooth: $bt"           "noop"
add "󰌆  VPN: $vpn_str"            "noop"
add "󰩟  IP: ${wifi_ip:-N/A}"      "noop"
add "󰏔  Updates: $total"          "noop"
add "─────────────"                "noop"
add "󰤨  WiFi Settings"            "wifi"
add "󰂯  Bluetooth Settings"       "bt"
add "󰏔  Run Updates"              "updates"

choice_idx=$(printf '%s\n' "${options[@]}" | rofi -dmenu -theme ~/.config/rofi/dropdown.rasi -p "󰤨 Network" -mesg "j/k nav · l select · q close" -format i)

[[ -z "$choice_idx" ]] && exit 0

case "${actions[$choice_idx]}" in
    wifi)    nm-connection-editor & ;;
    bt)      blueman-manager & ;;
    updates) kitty -e paru & ;;
esac
