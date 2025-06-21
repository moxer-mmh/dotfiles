#!/bin/bash
# 🚀 Space Station Auto-Startup Script
# Ensures all space station services start automatically

echo "🚀 Launching Space Station Services..."

# Wait for Hyprland to be fully ready
sleep 2

# Kill any existing processes first
pkill waybar 2>/dev/null
pkill swww-daemon 2>/dev/null
pkill -f wallpaper-cycle 2>/dev/null

# Start SWWW daemon for wallpaper management
echo "🌌 Starting wallpaper daemon..."
swww-daemon &

echo "🎨 Setting initial cosmic wallpaper symlink..."
INIT_WP=$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
ln -sf "$INIT_WP" ~/.config/hypr/current_wallpaper

# Wait a bit for swww-daemon to initialize
sleep 1

# Start wallpaper cycling
echo "🖼️  Starting wallpaper cycling..."
~/.config/hypr/scripts/wallpaper-cycle.sh &

# Start Waybar (Space Station Control Panel)
echo "🎮 Starting Space Station Control Panel..."
waybar &

# Start Battery Monitor
echo "🔋 Starting Battery Health Monitor..."
~/.config/hypr/scripts/battery-monitor.sh monitor &


# Start notification daemon
echo "🔔 Starting notifications..."
swaync &

# Start idle management
echo "⏰ Starting idle management..."
hypridle &

# Set initial wallpaper
echo "🎨 Setting initial cosmic wallpaper..."
sleep 2
WALLPAPER=$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
if [ -n "$WALLPAPER" ]; then
    swww img "$WALLPAPER" --transition-type fade --transition-duration 2
fi

echo "✨ Space Station fully operational!"
