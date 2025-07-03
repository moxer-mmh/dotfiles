#!/bin/bash
# Hybrid microphone volume script for Waybar using multiple detection methods

# Function to get current microphone status and output JSON
get_mic_status() {
  MIC_VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null || echo "Volume: 1.00")
  MIC_VOL=$(echo "$MIC_VOL_RAW" | awk '{print int($2 * 100)}')

  # Check if muted
  if echo "$MIC_VOL_RAW" | grep -q "MUTED"; then
    echo "{\"text\": \"󰍭 MUTED\", \"class\": \"muted\", \"percentage\": 0}"
  else
    echo "{\"text\": \"󰍬 $MIC_VOL%\", \"class\": \"\", \"percentage\": $MIC_VOL}"
  fi
}

# Output initial state
get_mic_status

# Try event-based monitoring, but fall back to polling if it fails
(
  # Try PipeWire/PulseAudio event monitoring
  (pactl subscribe 2>/dev/null | grep --line-buffered "source" | while read -r line; do
    if [[ "$line" == *"change"* ]] || [[ "$line" == *"new"* ]]; then
      get_mic_status
    fi
  done) &

  # Also do polling as a fallback, but with a longer interval
  while true; do
    get_mic_status
    sleep 1
  done
) &

# Wait for any child process to finish (they shouldn't unless there's an error)
wait
