#!/bin/bash

CAMERA_STATE_FILE="/tmp/.camera_state"
FAKE_CAM_DEV="/dev/video99"

# Ensure state file exists
[[ ! -f "$CAMERA_STATE_FILE" ]] && echo "enabled" >"$CAMERA_STATE_FILE"

current_state=$(cat "$CAMERA_STATE_FILE" 2>/dev/null || echo "enabled")

enable_camera() {
	echo "enabled" >"$CAMERA_STATE_FILE"
	# Remove fake device if exists
	if [[ -e "$FAKE_CAM_DEV" ]]; then
		sudo rmmod v4l2loopback 2>/dev/null || true
	fi
	notify-send "📷 Camera Enabled" "Camera is now usable" -i camera-enabled
}

disable_camera() {
	echo "disabled" >"$CAMERA_STATE_FILE"
	# Add fake camera device for blocking
	if ! [[ -e "$FAKE_CAM_DEV" ]]; then
		sudo modprobe v4l2loopback devices=1 video_nr=99 card_label="FakeCam" exclusive_caps=1 2>/dev/null || true
		# Ensure readable permissions
		[[ -e "$FAKE_CAM_DEV" ]] && sudo chmod 666 "$FAKE_CAM_DEV"
	fi
	notify-send "📷 Camera Disabled" "Camera is now blocked" -i camera-disabled
}

toggle_camera() {
	if [[ "$current_state" == "enabled" ]]; then
		disable_camera
	else
		enable_camera
	fi
}

case "$1" in
toggle | "")
	toggle_camera
	;;
enable)
	enable_camera
	;;
disable)
	disable_camera
	;;
status)
	echo "$current_state"
	;;
*)
	echo "Usage: $0 [toggle|enable|disable|status]"
	;;
esac

exit 0
