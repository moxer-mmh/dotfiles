#!/bin/bash

get_camera_status() {
	local output=""
	local camera_available=0
	local camera_blocked=0
	local camera_in_use=0
	local f6_state="unknown"

	if [[ -f "/tmp/.camera_state" ]]; then
		f6_state=$(cat "/tmp/.camera_state")
	fi

	local video_devices=($(find /dev -name "video*" 2>/dev/null))

	if [[ ${#video_devices[@]} -gt 0 ]]; then

		local video_in_use=0

		for device in "${video_devices[@]}"; do

			if lsof "$device" 2>/dev/null | grep -q "$device"; then
				video_in_use=1
				break
			fi
		done

		if [[ "$video_in_use" -eq 1 ]]; then

			camera_in_use=1
			camera_available=1
		else

			for device in "${video_devices[@]}"; do

				if [[ -r "$device" ]] && timeout 0.2 v4l2-ctl --device="$device" --list-formats >/dev/null 2>&1; then
					camera_available=1
					break
				fi
			done
		fi
	else

		camera_blocked=1
	fi

	local usb_camera_present=0

	if lsusb 2>/dev/null | grep -i "camera\|webcam" >/dev/null; then
		usb_camera_present=1
	fi

	local camera_modules_loaded=0

	if lsmod | grep -E "uvcvideo|gspca|pwc" >/dev/null 2>&1; then
		camera_modules_loaded=1
	fi

	if [[ "$f6_state" == "disabled" ]]; then

		output="<span color='#FF4500'>󰖠</span>"

	elif [[ ${#video_devices[@]} -eq 0 && "$usb_camera_present" -eq 0 ]]; then
		output="<span color='#FF4500'>󰖠</span>"

	elif [[ ${#video_devices[@]} -eq 0 && "$usb_camera_present" -eq 1 ]]; then

		output="<span color='#FF4500'>󰖠</span>"

	elif [[ "$camera_in_use" -eq 1 ]]; then

		output="<span color='#FFD700'>󰄁</span>"

	elif [[ "$camera_available" -eq 1 ]]; then

		output="<span color='#00FF7F'>󰄀</span>"

	else

		if [[ "$camera_modules_loaded" -eq 1 ]]; then
			output="<span color='#00FF7F'>󰄀</span>"
		else
			output="<span color='#666666'>󰄀</span>"
		fi
	fi

	echo "$output"
}

show_camera_tooltip() {
	local tooltip="Camera Status:\\n"
	local f6_state="Not tracked"

	if [[ -f "/tmp/.camera_state" ]]; then
		f6_state=$(cat "/tmp/.camera_state")
	fi

	local video_devices=($(find /dev -name "video*" 2>/dev/null))
	local devices_count=${#video_devices[@]}

	local usb_cameras=$(lsusb 2>/dev/null | grep -i "camera\|webcam" | wc -l)

	local modules_loaded=$(lsmod | grep -E "uvcvideo|gspca|pwc" | wc -l)

	tooltip+="F6 Key State: $f6_state\\n"
	tooltip+="Video Devices: $devices_count found\\n"
	tooltip+="USB Cameras: $usb_cameras detected\\n"
	tooltip+="Camera Modules: $modules_loaded loaded\\n\\n"

	if [[ $devices_count -gt 0 ]]; then
		tooltip+="Available Devices:\\n"

		for device in "${video_devices[@]}"; do

			local device_name=$(v4l2-ctl --device="$device" --info 2>/dev/null | grep "Card type" | cut -d: -f2 | xargs)

			if [[ -n "$device_name" ]]; then
				tooltip+="$device: $device_name\\n"
			else
				tooltip+="$device: Video Device\\n"
			fi

			if lsof "$device" 2>/dev/null | grep -q "$device"; then

				local processes=$(lsof "$device" 2>/dev/null | grep "$device" | awk '{print $1}' | sort -u | tr '\n' ' ')
				tooltip+="  → Used by: $processes\\n"
			else
				tooltip+="  → Available\\n"
			fi
		done
	else

		tooltip+="No video devices found\\n"

		if [[ $usb_cameras -gt 0 ]]; then

			tooltip+="(USB camera detected but disabled - try F6 key)\\n"
		else

			tooltip+="(No camera hardware detected)\\n"
		fi
	fi

	echo -e "$tooltip"
}

case "$1" in
"status")

	get_camera_status
	;;
"tooltip")

	show_camera_tooltip
	;;
*)
	get_camera_status
	;;
esac
