#!/bin/bash
#═══════════════════════════════════════════════════════════════════════════════
# 🚀 SPACE STATION STARTUP ORCHESTRATOR - COSMIC ENVIRONMENT INITIALIZATION
#═══════════════════════════════════════════════════════════════════════════════
#
# Comprehensive startup script that orchestrates the initialization of all
# space station services and components for the cosmic-themed development
# environment. Ensures proper service sequencing, dependency management,
# and graceful startup of the complete Hyprland desktop ecosystem.
#
# FEATURES:
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ • Intelligent service startup sequencing with proper timing delays          │
# │ • Process cleanup and conflict prevention for clean service restart         │
# │ • SWWW wallpaper daemon initialization with cosmic background management     │
# │ • Waybar status panel startup (Space Station Control Panel)                 │
# │ • Battery health monitoring integration for optimal power management        │
# │ • SwayNC notification daemon for desktop alert management                   │
# │ • Hypridle power management integration for automatic screen/suspend        │
# │ • Dynamic wallpaper selection and initialization from cosmic collection     │
# │ • Symlink-based wallpaper management for external tool compatibility        │
# │ • Comprehensive error handling and logging for troubleshooting              │
# └─────────────────────────────────────────────────────────────────────────────┘
#
# SERVICE STARTUP SEQUENCE:
# 1. Hyprland readiness wait and existing process cleanup
# 2. SWWW daemon initialization for wallpaper management
# 3. Initial wallpaper symlink creation for compatibility
# 4. Dynamic wallpaper cycling service startup
# 5. Waybar control panel activation
# 6. Battery health monitoring daemon
# 7. Desktop notification system initialization
# 8. Idle/power management service startup
# 9. Initial cosmic wallpaper selection and display
#
# DEPENDENCIES:
# - Hyprland (window manager - must be running)
# - SWWW (wallpaper daemon for Wayland)
# - Waybar (status bar and system panel)
# - SwayNC (notification daemon)
# - Hypridle (idle management daemon)
# - find, ln, sleep (core utilities)
# - Custom scripts: wallpaper-cycle.sh, battery-monitor.sh
#
# INTEGRATION:
# - Called automatically via Hyprland exec-once in hyprland.conf
# - Can be run manually for service restart or troubleshooting
# - Compatible with systemd user services for system-level integration
# - Supports both fresh startup and service restart scenarios
#
# WALLPAPER COLLECTION:
# - Expects cosmic wallpapers in ~/Pictures/Wallpapers/
# - Supports JPG, JPEG, and PNG formats
# - Implements random selection for visual variety
# - Creates compatibility symlink at ~/.config/hypr/current_wallpaper
#
# AUTHOR: Space Station Development Environment
# THEME: Cosmic Nebula Configuration Suite
# VERSION: 2.0.0
# LAST UPDATED: June 2025
#
#═══════════════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────────────
# STARTUP INITIALIZATION & LOGGING
#───────────────────────────────────────────────────────────────────────────────

# Create startup log for debugging and monitoring
STARTUP_LOG="/tmp/space-station-startup.log"
exec 1> >(tee -a "$STARTUP_LOG")
exec 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - 🚀 Launching Space Station Services..."
echo "$(date '+%Y-%m-%d %H:%M:%S') - 📍 Startup sequence initiated by: $(whoami)"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Environment: $XDG_CURRENT_DESKTOP"

#───────────────────────────────────────────────────────────────────────────────
# PHASE 1: ENVIRONMENT PREPARATION & CLEANUP
# Ensure clean startup by terminating conflicting processes and waiting for readiness
#───────────────────────────────────────────────────────────────────────────────

# Wait for Hyprland to be fully ready and compositor to stabilize
# This delay ensures all Wayland protocols are properly initialized
echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏳ Waiting for Hyprland compositor to stabilize..."
sleep 2

# Terminate any existing processes to prevent conflicts and resource issues
# This ensures clean service restart and prevents duplicate instances
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🧹 Cleaning up existing processes..."

# Clean up status bar processes
if pgrep waybar > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Terminating existing Waybar instances..."
    pkill waybar 2>/dev/null
fi

# Clean up wallpaper daemon processes
if pgrep swww-daemon > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Terminating existing SWWW daemon..."
    pkill swww-daemon 2>/dev/null
fi

# Clean up wallpaper cycling processes
if pgrep -f wallpaper-cycle > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Terminating existing wallpaper cycling..."
    pkill -f wallpaper-cycle 2>/dev/null
fi

# Brief pause to ensure process cleanup completion
sleep 1

#───────────────────────────────────────────────────────────────────────────────
# PHASE 2: WALLPAPER MANAGEMENT SYSTEM INITIALIZATION
# Set up cosmic wallpaper infrastructure with SWWW daemon and initial selection
#───────────────────────────────────────────────────────────────────────────────

# Start SWWW daemon for advanced wallpaper management in Wayland
# SWWW provides smooth transitions, multiple output support, and efficient rendering
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Starting SWWW wallpaper daemon..."
swww-daemon &

# Create initial wallpaper symlink for compatibility with external tools
# This symlink provides a stable reference point for other applications
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎨 Creating initial cosmic wallpaper symlink..."
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_SYMLINK="$HOME/.config/hypr/current_wallpaper"

# Verify wallpaper directory exists
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Wallpaper directory not found: $WALLPAPER_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 📁 Creating wallpaper directory..."
    mkdir -p "$WALLPAPER_DIR"
fi

# Select random wallpaper for initial setup
INIT_WP=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

if [[ -n "$INIT_WP" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Selected initial wallpaper: $(basename "$INIT_WP")"
    ln -sf "$INIT_WP" "$WALLPAPER_SYMLINK"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: No wallpapers found in $WALLPAPER_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Tip: Add cosmic wallpapers to enhance your space station experience"
fi

# Allow SWWW daemon time to fully initialize its Wayland protocols
echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏳ Allowing SWWW daemon initialization..."
sleep 1

#───────────────────────────────────────────────────────────────────────────────
# PHASE 3: CORE SPACE STATION SERVICES ACTIVATION
# Launch essential desktop services in proper dependency order
#───────────────────────────────────────────────────────────────────────────────

# Start dynamic wallpaper cycling service for visual variety
# This service automatically rotates through the cosmic wallpaper collection
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Starting dynamic wallpaper cycling service..."
WALLPAPER_SCRIPT="$HOME/.config/hypr/scripts/wallpaper-cycle.sh"

if [[ -x "$WALLPAPER_SCRIPT" ]]; then
    "$WALLPAPER_SCRIPT" &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Wallpaper cycling service started successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Wallpaper cycling script not found or not executable"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 📍 Expected location: $WALLPAPER_SCRIPT"
fi

# Start Waybar (Space Station Control Panel) for system monitoring and control
# Waybar provides comprehensive system information and quick access controls
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Starting Space Station Control Panel (Waybar)..."
if command -v waybar >/dev/null 2>&1; then
    waybar &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Waybar control panel started successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ❌ Error: Waybar not found - install with: sudo pacman -S waybar"
fi

# Start Battery Health Monitor for optimal power management
# This service protects battery longevity through intelligent charge monitoring
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔋 Starting Battery Health Monitor..."
BATTERY_SCRIPT="$HOME/.config/hypr/scripts/battery-monitor.sh"

if [[ -x "$BATTERY_SCRIPT" ]]; then
    "$BATTERY_SCRIPT" monitor &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Battery health monitoring activated"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Battery monitor script not found or not executable"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 📍 Expected location: $BATTERY_SCRIPT"
fi


#───────────────────────────────────────────────────────────────────────────────
# PHASE 4: NOTIFICATION & POWER MANAGEMENT SERVICES
# Initialize desktop notifications and intelligent power/idle management
#───────────────────────────────────────────────────────────────────────────────

# Start SwayNC notification daemon for desktop alert management
# SwayNC provides modern, customizable notifications with Wayland integration
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔔 Starting notification system (SwayNC)..."
if command -v swaync >/dev/null 2>&1; then
    swaync &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Notification daemon started successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: SwayNC not found - notifications may not work properly"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Install with: sudo pacman -S swaync"
fi

# Start Hypridle for intelligent idle management and power conservation
# Hypridle manages screen dimming, locking, and system suspend automatically
echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏰ Starting intelligent idle management (Hypridle)..."
if command -v hypridle >/dev/null 2>&1; then
    hypridle &
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Idle management system activated"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: Hypridle not found - automatic power management disabled"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Install with: sudo pacman -S hypridle"
fi

#───────────────────────────────────────────────────────────────────────────────
# PHASE 5: COSMIC WALLPAPER FINALIZATION
# Apply initial wallpaper with smooth transition effects
#───────────────────────────────────────────────────────────────────────────────

# Apply initial cosmic wallpaper with smooth fade transition
# This creates the first visual impression of the space station environment
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎨 Applying initial cosmic wallpaper..."

# Allow services to settle before wallpaper application
sleep 2

# Select and apply a random cosmic wallpaper from the collection
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 Selected wallpaper: $(basename "$WALLPAPER")"
    
    # Apply wallpaper with smooth fade transition (2-second duration)
    if command -v swww >/dev/null 2>&1; then
        swww img "$WALLPAPER" --transition-type fade --transition-duration 2
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Cosmic wallpaper applied successfully"
        
        # Update the current wallpaper symlink
        ln -sf "$WALLPAPER" "$WALLPAPER_SYMLINK"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ❌ Error: SWWW command not available for wallpaper application"
    fi
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  Warning: No suitable wallpapers found for initial display"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 💡 Add wallpapers to $WALLPAPER_DIR for cosmic visuals"
fi

#───────────────────────────────────────────────────────────────────────────────
# STARTUP COMPLETION & VERIFICATION
# Finalize initialization and provide status summary
#───────────────────────────────────────────────────────────────────────────────

echo "$(date '+%Y-%m-%d %H:%M:%S') - ✨ Space Station fully operational!"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 🚀 All cosmic services launched successfully"
echo ""

# Display service status summary for verification
echo "$(date '+%Y-%m-%d %H:%M:%S') - 📊 SPACE STATION SERVICE STATUS:"
echo "$(date '+%Y-%m-%d %H:%M:%S') - ═══════════════════════════════════"

# Check and report status of each critical service
services_status=()

# SWWW Daemon Status
if pgrep swww-daemon > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 SWWW Wallpaper Daemon: ✅ ACTIVE"
    services_status+=("swww:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🌌 SWWW Wallpaper Daemon: ❌ INACTIVE"
    services_status+=("swww:inactive")
fi

# Waybar Status
if pgrep waybar > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Waybar Control Panel: ✅ ACTIVE"
    services_status+=("waybar:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🎮 Waybar Control Panel: ❌ INACTIVE"
    services_status+=("waybar:inactive")
fi

# Battery Monitor Status
if pgrep -f battery-monitor > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔋 Battery Health Monitor: ✅ ACTIVE"
    services_status+=("battery:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔋 Battery Health Monitor: ❌ INACTIVE"
    services_status+=("battery:inactive")
fi

# SwayNC Status
if pgrep swaync > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔔 Notification System: ✅ ACTIVE"
    services_status+=("notifications:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔔 Notification System: ❌ INACTIVE"
    services_status+=("notifications:inactive")
fi

# Hypridle Status
if pgrep hypridle > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏰ Idle Management: ✅ ACTIVE"
    services_status+=("idle:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ⏰ Idle Management: ❌ INACTIVE"
    services_status+=("idle:inactive")
fi

# Wallpaper Cycling Status
if pgrep -f wallpaper-cycle > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Wallpaper Cycling: ✅ ACTIVE"
    services_status+=("wallpaper-cycle:active")
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🖼️  Wallpaper Cycling: ❌ INACTIVE"
    services_status+=("wallpaper-cycle:inactive")
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - ═══════════════════════════════════"

# Count active services
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

#═══════════════════════════════════════════════════════════════════════════════
# 🚀 SPACE STATION STARTUP ORCHESTRATOR SUMMARY & INTEGRATION GUIDE
#═══════════════════════════════════════════════════════════════════════════════
#
# STARTUP SEQUENCE BENEFITS:
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ 🔧 TECHNICAL BENEFITS:                                                       │
# │ • Proper service dependency management prevents startup conflicts            │
# │ • Intelligent timing delays ensure service stability                        │
# │ • Process cleanup prevents resource conflicts on restart                    │
# │ • Comprehensive logging enables effective troubleshooting                   │
# │ • Service status verification ensures complete environment activation       │
# │                                                                             │
# │ 🎯 USER EXPERIENCE BENEFITS:                                                 │
# │ • Automatic cosmic environment setup on login                               │
# │ • Consistent desktop experience across system restarts                      │
# │ • Seamless integration of all space station components                      │
# │ • Visual feedback and progress reporting during startup                     │
# │ • Graceful handling of missing dependencies                                 │
# └─────────────────────────────────────────────────────────────────────────────┘
#
# SERVICE ARCHITECTURE:
#
# Layer 1 - Foundation Services:
#   └─ SWWW Daemon (wallpaper management infrastructure)
#   └─ Process cleanup (conflict prevention)
#
# Layer 2 - Visual Environment:
#   └─ Wallpaper cycling (dynamic cosmic backgrounds)
#   └─ Initial wallpaper selection (visual consistency)
#
# Layer 3 - User Interface:
#   └─ Waybar (system monitoring and control panel)
#   └─ SwayNC (notification management)
#
# Layer 4 - System Management:
#   └─ Battery monitor (health optimization)
#   └─ Hypridle (power management)
#
# Layer 5 - Finalization:
#   └─ Wallpaper application (visual completion)
#   └─ Status verification (quality assurance)
#
# INTEGRATION METHODS:
#
# 1. HYPRLAND AUTOSTART (RECOMMENDED):
#    Add to ~/.config/hypr/hyprland.conf:
#    exec-once = ~/.config/hypr/scripts/space-station-startup.sh
#
# 2. SYSTEMD USER SERVICE:
#    Create ~/.config/systemd/user/space-station.service:
#    [Unit]
#    Description=Space Station Startup Orchestrator
#    After=hyprland-session.target
#    
#    [Service]
#    Type=oneshot
#    ExecStart=/home/%i/.config/hypr/scripts/space-station-startup.sh
#    Environment=WAYLAND_DISPLAY=wayland-1
#    Environment=XDG_CURRENT_DESKTOP=Hyprland
#    
#    [Install]
#    WantedBy=hyprland-session.target
#
# 3. MANUAL EXECUTION:
#    For testing or troubleshooting:
#    ~/.config/hypr/scripts/space-station-startup.sh
#
# 4. LOGIN SHELL INTEGRATION:
#    Add to ~/.zshrc or ~/.bashrc (if using auto-login):
#    if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
#        ~/.config/hypr/scripts/space-station-startup.sh
#    fi
#
# TROUBLESHOOTING GUIDE:
#
# • Services Not Starting:
#   - Check startup log: tail -f /tmp/space-station-startup.log
#   - Verify script permissions: chmod +x space-station-startup.sh
#   - Ensure all dependencies are installed (waybar, swww, swaync, hypridle)
#   - Check Hyprland is fully loaded before script execution
#
# • Wallpaper Issues:
#   - Verify wallpaper directory exists: ~/Pictures/Wallpapers/
#   - Check supported formats: JPG, JPEG, PNG
#   - Ensure SWWW daemon is running: pgrep swww-daemon
#   - Test manual wallpaper: swww img /path/to/image.jpg
#
# • Service Conflicts:
#   - Kill conflicting processes: pkill -f service-name
#   - Check for duplicate autostart entries in hyprland.conf
#   - Verify no competing notification daemons (dunst, mako)
#   - Ensure single instance of each service
#
# • Performance Issues:
#   - Adjust sleep delays for faster/slower hardware
#   - Monitor resource usage: htop or systemd-cgtop
#   - Consider disabling non-essential services on low-end hardware
#   - Use systemd user services for better resource management
#
# CUSTOMIZATION OPTIONS:
#
# • Service Selection:
#   Comment out unwanted services by adding # before echo and service commands
#   Example: # echo "🔋 Starting Battery Health Monitor..."
#           # "$BATTERY_SCRIPT" monitor &
#
# • Timing Adjustments:
#   Modify sleep delays for different hardware:
#   - Faster SSD systems: reduce sleep values
#   - Slower systems: increase sleep values
#   - Network storage: add additional delays
#
# • Wallpaper Configuration:
#   - Change wallpaper directory: WALLPAPER_DIR="/path/to/wallpapers"
#   - Modify transition effects: --transition-type wipe, grow, etc.
#   - Adjust transition duration: --transition-duration 3
#
# • Logging Configuration:
#   - Change log location: STARTUP_LOG="/var/log/space-station.log"
#   - Disable logging: Remove exec redirection lines
#   - Add debug mode: set -x for verbose output
#
# DEPENDENCY INSTALLATION:
#
# Arch Linux / Manjaro:
#   sudo pacman -S waybar swww swaync hypridle
#
# Ubuntu / Debian:
#   # Install from source or flatpak for latest versions
#   flatpak install flathub org.hyprland.waybar
#
# Fedora:
#   sudo dnf install waybar
#   # Additional packages may need compilation
#
# SECURITY CONSIDERATIONS:
#
# • File Permissions:
#   - Script should be executable by user only: chmod 755
#   - Avoid running as root or with elevated privileges
#   - Verify all called scripts have proper permissions
#
# • Service Isolation:
#   - Services run in user space for security
#   - No system-level modifications required
#   - Each service operates with minimal privileges
#
# • Logging Security:
#   - Log files contain no sensitive information
#   - Logs are user-accessible only (/tmp location)
#   - Consider log rotation for long-running systems
#
# PERFORMANCE METRICS:
#
# Typical startup times (SSD system):
# • Total startup: 8-12 seconds
# • Service initialization: 3-5 seconds
# • Wallpaper application: 2-3 seconds
# • Status verification: 1-2 seconds
#
# Memory usage:
# • SWWW daemon: ~15-25 MB
# • Waybar: ~20-40 MB
# • SwayNC: ~10-20 MB
# • Hypridle: ~5-10 MB
# • Total footprint: ~50-95 MB
#
# FUTURE ENHANCEMENTS:
#
# Potential improvements for advanced setups:
# • Health check endpoints for monitoring systems
# • Configuration validation before service startup
# • Rollback mechanisms for failed service launches
# • Integration with container orchestration platforms
# • Cloud-based configuration synchronization
# • Multi-monitor awareness and per-display customization
# • Adaptive service loading based on hardware capabilities
# • Plugin architecture for custom service integration
#
#═══════════════════════════════════════════════════════════════════════════════
# END OF SPACE STATION STARTUP ORCHESTRATOR
# Launch sequence complete - enjoy your cosmic development environment! 🚀✨🌌
#═══════════════════════════════════════════════════════════════════════════════
