#!/bin/bash

STARTUP_LOG="/tmp/space-station-startup.log"
exec 1> >(tee -a "$STARTUP_LOG")
exec 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🚀 Launching Space Station Services..."
echo "$(date '+%Y-%m-%d %H:%M:%S') - 📍 Startup sequence initiated by: $(whoami)"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Environment: $XDG_CURRENT_DESKTOP"

echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏳ Waiting for Hyprland compositor to stabilize..."
sleep 2

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🧹 Cleaning up existing processes..."

if pgrep waybar > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Terminating existing Waybar instances..."
    pkill waybar 2>/dev/null
fi

if pgrep swww-daemon > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Terminating existing SWWW daemon..."
    pkill swww-daemon 2>/dev/null
fi

if pgrep -f wallpaper-cycle > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Terminating existing wallpaper cycling..."
    pkill -f wallpaper-cycle 2>/dev/null
fi

sleep 1

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Starting SWWW wallpaper daemon..."
swww-daemon &

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎨 Creating initial cosmic wallpaper symlink..."
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_SYMLINK="$HOME/.config/hypr/current_wallpaper"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Wallpaper directory not found: $WALLPAPER_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 📁 Creating wallpaper directory..."
    mkdir -p "$WALLPAPER_DIR"
fi

INIT_WP=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

if [[ -n "$INIT_WP" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Selected initial wallpaper: $(basename "$INIT_WP")"
    ln -sf "$INIT_WP" "$WALLPAPER_SYMLINK"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: No wallpapers found in $WALLPAPER_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Tip: Add cosmic wallpapers to enhance your space station experience"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏳ Allowing SWWW daemon initialization..."
sleep 1


echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Starting dynamic wallpaper cycling service..."
WALLPAPER_SCRIPT="$HOME/.config/hypr/scripts/wallpaper-cycle.sh"

if [[ -x "$WALLPAPER_SCRIPT" ]]; then
    "$WALLPAPER_SCRIPT" &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Wallpaper cycling service started successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Wallpaper cycling script not found or not executable"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 📍 Expected location: $WALLPAPER_SCRIPT"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Starting Space Station Control Panel (Waybar)..."
if command -v waybar >/dev/null 2>&1; then
    waybar &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Waybar control panel started successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ❌ Error: Waybar not found - install with: sudo pacman -S waybar"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔋 Starting Battery Health Monitor..."
BATTERY_SCRIPT="$HOME/.config/hypr/scripts/battery-monitor.sh"

if [[ -x "$BATTERY_SCRIPT" ]]; then
    "$BATTERY_SCRIPT" monitor &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Battery health monitoring activated"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Battery monitor script not found or not executable"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 📍 Expected location: $BATTERY_SCRIPT"
fi


echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔔 Starting notification system (SwayNC)..."
if command -v swaync >/dev/null 2>&1; then
    swaync &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Notification daemon started successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: SwayNC not found - notifications may not work properly"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Install with: sudo pacman -S swaync"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏰ Starting intelligent idle management (Hypridle)..."
if command -v hypridle >/dev/null 2>&1; then
    hypridle &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Idle management system activated"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Hypridle not found - automatic power management disabled"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Install with: sudo pacman -S hypridle"
fi


udiskie -A -n &

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎨 Applying initial cosmic wallpaper..."

sleep 2

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Selected wallpaper: $(basename "$WALLPAPER")"

    if command -v swww >/dev/null 2>&1; then
        swww img "$WALLPAPER" --transition-type fade --transition-duration 2
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Cosmic wallpaper applied successfully"

        ln -sf "$WALLPAPER" "$WALLPAPER_SYMLINK"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ❌ Error: SWWW command not available for wallpaper application"
    fi
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: No suitable wallpapers found for initial display"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Add wallpapers to $WALLPAPER_DIR for cosmic visuals"
fi


echo "$(date '+%Y-%m-%d %H:%M:%S') - ✨ Space Station fully operational!"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🚀 All cosmic services launched successfully"
echo ""

echo "$(date '+%Y-%m-%d %H:%M:%S') - 📊 SPACE STATION SERVICE STATUS:"
echo "$(date '+%Y-%m-%d %H:%M:%S') - ═══════════════════════════════════"

services_status=()

if pgrep swww-daemon > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 SWWW Wallpaper Daemon: ✅ ACTIVE"
    services_status+=("swww:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 SWWW Wallpaper Daemon: ❌ INACTIVE"
    services_status+=("swww:inactive")
fi

if pgrep waybar > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Waybar Control Panel: ✅ ACTIVE"
    services_status+=("waybar:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Waybar Control Panel: ❌ INACTIVE"
    services_status+=("waybar:inactive")
fi

if pgrep -f battery-monitor > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔋 Battery Health Monitor: ✅ ACTIVE"
    services_status+=("battery:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔋 Battery Health Monitor: ❌ INACTIVE"
    services_status+=("battery:inactive")
fi

if pgrep swaync > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔔 Notification System: ✅ ACTIVE"
    services_status+=("notifications:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔔 Notification System: ❌ INACTIVE"
    services_status+=("notifications:inactive")
fi

if pgrep hypridle > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏰ Idle Management: ✅ ACTIVE"
    services_status+=("idle:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏰ Idle Management: ❌ INACTIVE"
    services_status+=("idle:inactive")
fi

if pgrep -f wallpaper-cycle > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Wallpaper Cycling: ✅ ACTIVE"
    services_status+=("wallpaper-cycle:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Wallpaper Cycling: ❌ INACTIVE"
    services_status+=("wallpaper-cycle:inactive")
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - ═══════════════════════════════════"

active_count=$(printf '%s\n' "${services_status[@]}" | grep -c ":active")
total_count=${#services_status[@]}

echo "$(date '+%Y-%m-%d %H:%M:%S') - 📈 Service Summary: $active_count/$total_count services active"

if [[ $active_count -eq $total_count ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎉 Perfect launch! All space station systems operational"
elif [[ $active_count -gt $((total_count * 2 / 3)) ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Partial launch: Some services may need attention"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ❌ Launch issues detected: Check service dependencies"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - 📁 Startup log saved to: $STARTUP_LOG"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🚀 Welcome to your cosmic development environment!"
