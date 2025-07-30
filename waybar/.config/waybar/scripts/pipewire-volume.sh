#!/bin/bash

get_volume_status() {
	VOLUME_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 1.00")
	VOLUME=$(echo "$VOLUME_RAW" | awk '{print int($2 * 100)}')

	if echo "$VOLUME_RAW" | grep -q "MUTED"; then
		echo "{\"text\": \"󰝟 MUTED\", \"class\": \"muted\", \"percentage\": 0}"
	else
		echo "{\"text\": \"󰕾 $VOLUME%\", \"class\": \"\", \"percentage\": $VOLUME}"
	fi
}

get_volume_status

(
	(pactl subscribe 2>/dev/null | grep --line-buffered "sink" | while read -r line; do
		if [[ "$line" == *"change"* ]] || [[ "$line" == *"new"* ]]; then
			get_volume_status
		fi
	done) &

	while true; do
		get_volume_status
		sleep 1
	done
) &

wait
