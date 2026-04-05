#!/bin/bash
# Hardware dropdown — vim keys: j/k navigate, l/Enter select, q/Esc close

cpu=$(awk '/^cpu / {printf "%d", ($2+$4)*100/($2+$4+$5)}' /proc/stat)
mem_pct=$(free | awk '/^Mem:/ {printf "%d", $3/$2*100}')
mem_used=$(free -h | awk '/^Mem:/ {print $3}')
mem_total=$(free -h | awk '/^Mem:/ {print $2}')

temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
[[ -n "$temp_raw" ]] && temp="$((temp_raw/1000))°C" || temp="N/A"

if command -v nvidia-smi &>/dev/null; then
    gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    gpu_str="${gpu}% · ${gpu_temp}°C"
else
    gpu_str="N/A"
fi

disk=$(df -h / | awk 'NR==2 {printf "%s / %s (%s)", $3, $2, $5}')
load=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
up=$(uptime -p | sed 's/up //')

declare -A actions
idx=0
add() { options+=("$1"); actions[$idx]="$2"; ((idx++)); }

options=()
add "󰻠  CPU: ${cpu}%"              "noop"
add "󰍛  RAM: ${mem_pct}% · ${mem_used}/${mem_total}" "noop"
add "󰔏  Temp: ${temp}"            "noop"
add "󰾲  GPU: ${gpu_str}"          "noop"
add "󰋊  Disk: ${disk}"            "noop"
add "󰔟  Load: ${load}"            "noop"
add "󰅐  Up: ${up}"                "noop"
add "─────────────"                "noop"
add "󰍹  System Monitor"           "htop"
add "󰾲  GPU Monitor"              "gpu"

choice_idx=$(printf '%s\n' "${options[@]}" | rofi -dmenu -theme ~/.config/rofi/dropdown.rasi -p "󰻠 Hardware" -mesg "j/k nav · l select · q close" -format i)

[[ -z "$choice_idx" ]] && exit 0

case "${actions[$choice_idx]}" in
    htop) kitty -e htop & ;;
    gpu)  kitty -e watch -n1 nvidia-smi & ;;
esac
