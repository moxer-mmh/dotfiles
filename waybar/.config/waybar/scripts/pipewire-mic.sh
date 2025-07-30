#!/bin/bash

get_mic_status() {
	MIC_VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null || echo "Volume: 1.00")
	MIC_VOL=$(echo "$MIC_VOL_RAW" | awk '{print int($2 * 100)}')

	if echo "$MIC_VOL_RAW" | grep -q "MUTED"; then
		echo "{\"text\": \"󰍭 MUTED\", \"class\": \"muted\", \"percentage\": 0}"
	else
		echo "{\"text\": \"󰍬 $MIC_VOL%\", \"class\": \"\", \"percentage\": $MIC_VOL}"
	fi
}

get_mic_status

(
	(pactl subscribe 2>/dev/null | grep --line-buffered "source" | while read -r line; do
		if [[ "$line" == *"change"* ]] || [[ "$line" == *"new"* ]]; then
			get_mic_status
		fi
	done) &

	while true; do
		get_mic_status
		sleep 1
	done
) &

wait
