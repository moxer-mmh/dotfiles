#!/bin/bash
# Shows NVIDIA util | watts | vram; sets class "on"/"off" for CSS.

if ! command -v nvidia-smi &>/dev/null; then
	echo '{"text":"󰢮 N/A","class":"off","tooltip":"NVIDIA not installed"}'
	exit 0
fi

data=$(nvidia-smi --query-gpu=utilization.gpu,power.draw,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)

if [[ -z "$data" ]]; then
	echo '{"text":"󰢮 Off","class":"off","tooltip":"NVIDIA GPU is sleeping"}'
else
	util=$(echo "$data" | awk -F, '{print $1}' | tr -d ' ')
	watts=$(echo "$data" | awk -F, '{print $2}' | tr -d ' ')
	vramu=$(echo "$data" | awk -F, '{print $3}' | tr -d ' ')
	vramt=$(echo "$data" | awk -F, '{print $4}' | tr -d ' ')
	echo "{\"text\":\"󰢮 ${util}% | ${watts}W | ${vramu}/${vramt}MB\",\"class\":\"on\",\"tooltip\":\"NVIDIA active\"}"
fi
