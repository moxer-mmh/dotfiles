#!/bin/bash
# Hybrid audio volume script for Waybar using multiple detection methods

# Function to get current volume status and output JSON
get_volume_status() {
  VOLUME_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 1.00")
  VOLUME=$(echo "$VOLUME_RAW" | awk '{print int($2 * 100)}')

  # Check if muted
  if echo "$VOLUME_RAW" | grep -q "MUTED"; then
    echo "{\"text\": \"󰝟 MUTED\", \"class\": \"muted\", \"percentage\": 0}"
  else
    echo "{\"text\": \"󰕾 $VOLUME%\", \"class\": \"\", \"percentage\": $VOLUME}"
  fi
}

# Output initial state
get_volume_status

# Try event-based monitoring, but fall back to polling if it fails
(
  # Try PipeWire/PulseAudio event monitoring
  (pactl subscribe 2>/dev/null | grep --line-buffered "sink" | while read -r line; do
    if [[ "$line" == *"change"* ]] || [[ "$line" == *"new"* ]]; then
      get_volume_status
    fi
  done) &

  # Also do polling as a fallback, but with a longer interval
  while true; do
    get_volume_status
    sleep 1
  done
) &

# Wait for any child process to finish (they shouldn't unless there's an error)
wait
