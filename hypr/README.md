# 🚀 Space Station Hyprland Configuration

<div align="center">

![Hyprland](https://img.shields.io/badge/Hyprland-0.41+-blue?style=for-the-badge&logo=hyprland)
![Wayland](https://img.shields.io/badge/Wayland-Compatible-green?style=for-the-badge)
![AZERTY](https://img.shields.io/badge/AZERTY-Optimized-yellow?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production_Ready-brightgreen?style=for-the-badge)

**A cosmic-themed Wayland compositor experience with cyberpunk aesthetics**  
*Dual monitor support • AZERTY keyboard layout • Development-focused workflow*

</div>

---

## 📋 **Table of Contents**

- [✨ Features](#-features)
- [🎨 Visual Preview](#-visual-preview)  
- [📁 Configuration Structure](#-configuration-structure)
- [🛠️ Installation](#-installation)
- [⌨️ Keybindings Reference](#️-keybindings-reference)
- [🎯 Workspace Organization](#-workspace-organization)
- [🔧 Script Ecosystem](#-script-ecosystem)
- [🛡️ Security & Power Management](#️-security--power-management)
- [🔧 Customization](#-customization)
- [🐛 Troubleshooting](#-troubleshooting)
- [📚 Additional Resources](#-additional-resources)

---

## ✨ **Features**

### 🌌 **Cosmic Aesthetics**
- **Dynamic RGB borders** with electric purple → cosmic cyan → neon green gradient
- **Transparent windows** with blur effects for depth (80-95% opacity)
- **Animated wallpaper cycling** every 30 seconds with smooth transitions
- **Cyberpunk color scheme** throughout all components
- **Custom cosmic animations** with space-themed bezier curves

### 🖥️ **Dual Monitor Setup**
- **Primary Display**: 1920x1080@144Hz (main coding screen)
- **Secondary Display**: 1280x1024@60Hz (documentation/monitoring)
- **Seamless window movement** between monitors
- **Independent wallpaper management** across displays

### ⌨️ **AZERTY Keyboard Optimization**
- **French locale support** with proper symbol key mappings
- **Dual workspace navigation** (AZERTY symbols + standard numbers)
- **Vim-style navigation** (HJKL) with arrow key alternatives
- **Development-focused shortcuts** for coding workflow

### 🔒 **Security & Power Management**
- **Intelligent idle management** with progressive power reduction
- **Secure lock screen** with cosmic authentication interface
- **Battery health monitoring** with 80% charge optimization
- **Camera privacy controls** with hardware detection

### 🎛️ **Smart Automation**
- **Automatic service orchestration** on startup
- **Dynamic wallpaper rotation** from cosmic collection
- **Workspace-based app assignment** for development workflow
- **Real-time system monitoring** with visual feedback
- **Persistent clipboard management** with text and image history

---

## 🎨 **Visual Preview**

### Color Palette
| Color | Hex Code | Usage | Preview |
|-------|----------|--------|---------|
| 🟢 **Neon Green** | `#00ff88` | Active borders, time display, success states | ![#00ff88](https://via.placeholder.com/20/00ff88/000000?text=+) |
| 🟣 **Electric Purple** | `#8844ff` | Border gradients, lock screen elements | ![#8844ff](https://via.placeholder.com/20/8844ff/000000?text=+) |
| 🔵 **Cosmic Cyan** | `#00aaff` | Accent colors, system information | ![#00aaff](https://via.placeholder.com/20/00aaff/000000?text=+) |
| ⚫ **Space Black** | `#1e1e2e` | Background, input fields | ![#1e1e2e](https://via.placeholder.com/20/1e1e2e/000000?text=+) |
| 🔴 **Alert Red** | `#ff4444` | Error states, failed authentication | ![#ff4444](https://via.placeholder.com/20/ff4444/000000?text=+) |

### Animation Effects
- **Window Open/Close**: Smooth scale transitions with bounce
- **Workspace Switching**: Vertical slide with space-themed easing
- **Border Animation**: Rotating RGB gradient (60° rotation)
- **Wallpaper Changes**: 2-second crossfade transitions

---

## 📁 **Configuration Structure**

```
hypr/
├── .config/hypr/
│   ├── hyprland.conf          # Main window manager configuration
│   ├── hyprlock.conf          # Secure lock screen with cosmic theme
│   ├── hypridle.conf          # Intelligent power management
│   ├── current_wallpaper      # Symlink to active wallpaper
│   └── scripts/
│       ├── space-station-startup.sh    # Service orchestration
│       ├── wallpaper-cycle.sh          # Dynamic background rotation
│       ├── battery-monitor.sh          # Health optimization system
│       └── camera-toggle.sh            # Privacy control system
```

### Configuration Files Overview

| File | Purpose | Key Features |
|------|---------|--------------|
| **hyprland.conf** | Main compositor config | Window rules, keybindings, animations, monitor setup |
| **hyprlock.conf** | Lock screen interface | Cosmic authentication, dynamic backgrounds, system status |
| **hypridle.conf** | Power management | Progressive idle stages, battery-aware suspend behavior |

---

## 🛠️ **Installation**

### 📋 **Prerequisites**

#### Core Requirements
```bash
# Arch Linux / Manjaro
sudo pacman -S hyprland hyprlock hypridle waybar rofi alacritty

# Additional dependencies
sudo pacman -S swww swaync brightnessctl playerctl

# Audio system (PipeWire)
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pavucontrol wireplumber

# Clipboard management
sudo pacman -S cliphist wl-clipboard

# Font requirements
sudo pacman -S ttf-jetbrains-mono-nerd
```

#### Optional Dependencies
```bash
# Screenshot utility
sudo pacman -S hyprshot

# Development tools
sudo pacman -S code brave-browser spotify-launcher

# System utilities
sudo pacman -S nautilus polkit-gnome networkmanager
```

### 📥 **Installation Methods**

#### Method 1: Using GNU Stow (Recommended)
```bash
# Clone the dotfiles repository
git clone https://github.com/moxer-mmh/dotfiles.git
cd dotfiles

# Install dependencies (see prerequisites above)

# Backup existing configuration
mv ~/.config/hypr ~/.config/hypr.backup 2>/dev/null || true

# Install with GNU Stow
stow hypr

# Verify installation
ls -la ~/.config/hypr/
```

#### Method 2: Manual Installation
```bash
# Clone repository
git clone https://github.com/moxer-mmh/dotfiles.git
cd dotfiles

# Copy configuration files
cp -r hypr/.config/hypr ~/.config/

# Make scripts executable
chmod +x ~/.config/hypr/scripts/*.sh

# Create wallpaper directory
mkdir -p ~/Pictures/Wallpapers
```

### 🖼️ **Wallpaper Setup**
```bash
# Create wallpaper directory
mkdir -p ~/Pictures/Wallpapers

# Add your cosmic wallpapers (JPG, JPEG, PNG)
# The system will automatically cycle through them

# Test wallpaper cycling
~/.config/hypr/scripts/wallpaper-cycle.sh
```

### 🚀 **First Launch**
```bash
# Start Hyprland (from TTY or display manager)
Hyprland

# Services will auto-start via space-station-startup.sh
# Check startup log if needed:
tail -f /tmp/space-station-startup.log
```

---

## ⌨️ **Keybindings Reference**

> **Note**: All keybindings use the **Super (Windows)** key as the main modifier

### 🚀 **Essential Controls**
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + Enter` | Launch Terminal | Open Alacritty terminal |
| `Super + Q` | Close Window | Kill active window |
| `Super + E` | File Manager | Open Nautilus |
| `Super + Space` | App Launcher | Open Rofi application menu |
| `Super + V` | Clipboard History | Open clipboard manager with Rofi |
| `Super + X` | Lock Screen | Activate Hyprlock immediately |
| `Super + F` | Fullscreen | Toggle fullscreen mode |
| `Super + T` | Split Direction | Toggle window split orientation |

### 🎯 **Development Applications**
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + C` | VS Code | Launch code editor |
| `Super + B` | Brave Browser | Open web browser |
| `Super + S` | Spotify | Launch music player |
| `Super + :` | Dev Session | Start tmux development session |
| `Super + Shift + D` | LazyDocker | Docker management interface |

### 📸 **Screenshots**
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + P` | Window Screenshot | Capture active window |
| `Super + Shift + P` | Region Screenshot | Select area to capture |
| `Print` | Window Screenshot | Alternative window capture |
| `Shift + Print` | Region Screenshot | Alternative region capture |

### 🧭 **Window Navigation** (Vim-style + Arrows)
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + H/←` | Focus Left | Move focus to left window |
| `Super + J/↓` | Focus Down | Move focus to window below |
| `Super + K/↑` | Focus Up | Move focus to window above |
| `Super + L/→` | Focus Right | Move focus to right window |

### 🚚 **Window Movement**
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + Shift + H/←` | Move Left | Move window left |
| `Super + Shift + J/↓` | Move Down | Move window down |
| `Super + Shift + K/↑` | Move Up | Move window up |
| `Super + Shift + L/→` | Move Right | Move window right |

### 📏 **Window Resizing**
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + Ctrl + H/←` | Shrink Width | Reduce window width |
| `Super + Ctrl + J/↓` | Expand Height | Increase window height |
| `Super + Ctrl + K/↑` | Shrink Height | Reduce window height |
| `Super + Ctrl + L/→` | Expand Width | Increase window width |

### 🖥️ **Multi-Monitor Management**
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + Alt + H/←` | Move to Left Monitor | Send window to left display |
| `Super + Alt + L/→` | Move to Right Monitor | Send window to right display |
| `Super + ,` | Focus Left Monitor | Switch focus to left monitor |
| `Super + .` | Focus Right Monitor | Switch focus to right monitor |

### 🌌 **Workspace Navigation** (AZERTY + Standard)

#### Navigate to Workspace
| AZERTY Shortcut | Standard Shortcut | Workspace | Purpose |
|----------------|-------------------|-----------|---------|
| `Super + &` | `Super + 1` | Workspace 1 | **Terminal** (Development) |
| `Super + é` | `Super + 2` | Workspace 2 | **Browser** (Research) |
| `Super + "` | `Super + 3` | Workspace 3 | **Code** (VS Code) |
| `Super + '` | `Super + 4` | Workspace 4 | **General** |
| `Super + (` | `Super + 5` | Workspace 5 | **Notes** (Obsidian) |
| `Super + -` | `Super + 6` | Workspace 6 | **General** |
| `Super + è` | `Super + 7` | Workspace 7 | **Music** (Spotify) |
| `Super + _` | `Super + 8` | Workspace 8 | **General** |
| `Super + ç` | `Super + 9` | Workspace 9 | **General** |
| `Super + à` | `Super + 0` | Workspace 10 | **General** |

#### Move Window to Workspace
Add `Shift` to any workspace navigation shortcut to move the active window:
- `Super + Shift + &/1` → Move window to workspace 1
- `Super + Shift + é/2` → Move window to workspace 2
- *(pattern continues for all workspaces)*

### 🖱️ **Mouse Controls**
| Action | Function |
|--------|----------|
| `Super + Left Click` | Move window |
| `Super + Right Click` | Resize window |
| `3-finger swipe` | Switch workspaces (touchpad) |

### 🎵 **Media Controls**
| Key | Action |
|-----|--------|
| `Volume Up/Down` | Adjust system volume |
| `Mute` | Toggle audio mute |
| `Play/Pause` | Control media playback |
| `Next/Previous` | Skip tracks |
| `Mic Mute` | Toggle microphone |

### 💡 **Display & Hardware Controls**
| Key | Action |
|-----|--------|
| `Brightness Up/Down` | Adjust screen brightness |
| `F6` | Toggle camera (MSI laptops) |
| `Super + F6` | Launch camera application |

---

## 🎯 **Workspace Organization**

The Space Station uses an intelligent workspace system designed for development workflow optimization:

### 📋 **Workspace Layout**

| Workspace | Purpose | Auto-Assigned Apps | Color Theme |
|-----------|---------|-------------------|-------------|
| **1 - Terminal** | Command line work | Alacritty | 🟢 Neon Green |
| **2 - Browser** | Research & testing | Brave Browser | 🔵 Cosmic Cyan |
| **3 - Code** | Development | VS Code | 🟣 Electric Purple |
| **4 - General** | Flexible workspace | - | ⚪ Neutral |
| **5 - Notes** | Documentation | Obsidian | 🟡 Cosmic Yellow |
| **6 - General** | Flexible workspace | - | ⚪ Neutral |
| **7 - Music** | Audio & entertainment | Spotify | 🔴 Cosmic Red |
| **8-10 - General** | Additional workspaces | - | ⚪ Neutral |

### 🔄 **Automatic App Assignment**

Applications automatically open in their designated workspaces:

```toml
# Development Workflow
Alacritty     → Workspace 1 (Terminal)
Brave Browser → Workspace 2 (Browser)
VS Code       → Workspace 3 (Code)
Obsidian      → Workspace 5 (Notes)
Spotify       → Workspace 7 (Music)
```

### 🎨 **Window Opacity Rules**

Different applications have cosmic transparency effects:
- **Terminals**: 90% opacity (balanced readability)
- **Code Editors**: 80% opacity (enhanced depth)
- **File Managers**: 90% opacity (clean interface)

---

## 🔧 **Script Ecosystem**

The Space Station Hyprland configuration includes a comprehensive suite of automation scripts:

### 🚀 **space-station-startup.sh**
**Main orchestration script that launches all services in proper sequence**

#### Features:
- **Service Sequencing**: Launches all components with proper timing delays
- **Process Cleanup**: Prevents conflicts by terminating existing instances
- **Comprehensive Logging**: Detailed startup log for troubleshooting
- **Service Verification**: Checks that all services started successfully

#### Integration:
```bash
# Auto-executed via Hyprland exec-once
exec-once = ~/.config/hypr/scripts/space-station-startup.sh

# Manual execution for testing
~/.config/hypr/scripts/space-station-startup.sh
```

### 🖼️ **wallpaper-cycle.sh**
**Dynamic wallpaper rotation system for visual variety**

#### Features:
- **Automatic Discovery**: Finds all wallpapers in `~/Pictures/Wallpapers/`
- **Random Selection**: Prevents predictable wallpaper order
- **Smooth Transitions**: 2-second fade effects between wallpapers
- **Multi-Format Support**: JPG, JPEG, and PNG files
- **SWWW Integration**: Uses modern Wayland wallpaper daemon

#### Configuration:
```bash
# Default rotation interval: 30 seconds
INTERVAL=30

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
```

### 🔋 **battery-monitor.sh**
**Intelligent battery health optimization system**

#### Features:
- **80% Charge Threshold**: Scientifically optimal for lithium-ion longevity
- **Smart Notifications**: Prevents spam with session-based tracking
- **Multiple Operation Modes**: monitor, check, status
- **Battery Health Education**: Provides tips for optimal battery care

#### Usage:
```bash
# Start continuous monitoring
~/.config/hypr/scripts/battery-monitor.sh monitor

# Quick battery check
~/.config/hypr/scripts/battery-monitor.sh check

# Detailed status report
~/.config/hypr/scripts/battery-monitor.sh status
```

### 📷 **camera-toggle.sh**
**Privacy-focused camera control for MSI laptops**

#### Features:
- **Hardware Detection**: Multiple methods to detect camera status
- **MSI Integration**: Optimized for MSI laptop F6 key
- **Privacy Protection**: Easy toggle for video calls and privacy
- **Visual Feedback**: Shows camera status in notifications

#### Keybinding:
```bash
# F6 key (MSI laptops)
bind = , F6, exec, ~/.config/hypr/scripts/camera-toggle.sh

# Super + F6 (launch camera app)
bind = $mainMod, F6, exec, cheese
```

---

## 🛡️ **Security & Power Management**

### 🔒 **Hyprlock Configuration**

#### Security Features:
- **Immediate Locking**: No grace period for maximum security
- **Dynamic Backgrounds**: Cosmic wallpapers continue during lock
- **Secure Authentication**: PAM integration with visual feedback
- **Failed Attempt Handling**: Clear indicators for authentication status

#### Visual Elements:
- **Time Display**: Large neon green clock (24-hour format)
- **Date Information**: Cosmic-themed date with system info
- **Battery Status**: Real-time power level monitoring
- **Password Field**: Cyberpunk-styled input with rounded corners

### ⚡ **Hypridle Power Management**

#### Progressive Power Stages:
1. **5 minutes**: Screen dimming to 10% brightness
2. **10 minutes**: Automatic screen lock activation
3. **15 minutes**: Display power off (DPMS)
4. **30 minutes**: System suspend (configurable)

#### Battery-Aware Features:
- **Low Battery Protection**: Earlier suspend on low battery
- **Charging Detection**: Adjusted behavior when plugged in
- **Wake Triggers**: Mouse movement and keyboard input restore full brightness

---

## 🔧 **Customization**

### 🎨 **Changing Colors**

#### Border Colors
```toml
# Edit hyprland.conf
col.active_border = rgba(8844ffff) rgba(00aaffff) rgba(00ff88ff) 60deg
col.inactive_border = rgba(2a2a40aa)
```

#### Lock Screen Colors
```toml
# Edit hyprlock.conf - Time Display
color = rgba(0, 255, 136, 1.0)  # Neon green

# Password Field
outer_color = rgba(136, 68, 255, 1.0)  # Purple border
font_color = rgba(0, 255, 136, 1.0)    # Green text
```

### 🖼️ **Wallpaper Management**

#### Adding New Wallpapers
```bash
# Add images to wallpaper directory
cp /path/to/cosmic-wallpaper.jpg ~/Pictures/Wallpapers/

# Supported formats: JPG, JPEG, PNG
# The system automatically discovers and cycles through all images
```

#### Changing Cycle Interval
```bash
# Edit wallpaper-cycle.sh
INTERVAL=30  # Change to desired seconds (30 = default)
```

### ⚡ **Animation Customization**

#### Window Animations
```toml
# Edit hyprland.conf - Custom bezier curves
bezier = spaceOut, 0.16, 1, 0.3, 1
bezier = spaceIn, 0.7, 0, 0.84, 0
bezier = spaceBounce, 0.68, -0.55, 0.265, 1.55

# Apply to animations
animation = windows, 1, 6, spaceOut
animation = workspaces, 1, 8, spaceBounce, slidevert
```

### 🔧 **Monitor Configuration**

#### Adding/Modifying Monitors
```toml
# Edit hyprland.conf
monitor=eDP-1,1920x1080@144,0x0,1          # Primary display
monitor=HDMI-A-1,1280x1024@60,1920x0,1     # Secondary display

# Format: monitor=name,resolution@refresh,position,scale
```

### ⌨️ **Custom Keybindings**

#### Adding New Shortcuts
```toml
# Edit hyprland.conf
bind = $mainMod, Y, exec, your-application
bind = $mainMod SHIFT, Y, exec, your-other-command
```

### 🔋 **Power Management Tuning**

#### Adjusting Idle Timeouts
```toml
# Edit hypridle.conf
listener {
    timeout = 300    # 5 minutes (change as needed)
    on-timeout = brightnessctl -s set 10
}
```

---

## 🐛 **Troubleshooting**

### 🚀 **Startup Issues**

#### Services Not Starting
```bash
# Check startup log
tail -f /tmp/space-station-startup.log

# Verify script permissions
chmod +x ~/.config/hypr/scripts/*.sh

# Test individual services
~/.config/hypr/scripts/space-station-startup.sh
```

#### Missing Dependencies
```bash
# Check for required packages
which waybar swww swaync hypridle

# Install missing packages (Arch Linux)
sudo pacman -S waybar swww swaync hypridle
```

### 🖼️ **Wallpaper Problems**

#### No Wallpapers Cycling
```bash
# Check wallpaper directory
ls ~/Pictures/Wallpapers/

# Test SWWW daemon
pgrep swww-daemon || swww-daemon &

# Manual wallpaper test
swww img ~/Pictures/Wallpapers/test-image.jpg
```

#### Wallpaper Not Changing
```bash
# Check wallpaper script
~/.config/hypr/scripts/wallpaper-cycle.sh

# Verify supported formats (JPG, JPEG, PNG)
find ~/Pictures/Wallpapers/ -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \)
```

### 🔒 **Lock Screen Issues**

#### Lock Screen Not Appearing
```bash
# Test Hyprlock manually
hyprlock

# Check configuration
hyprlock --config ~/.config/hypr/hyprlock.conf
```

#### Authentication Problems
```bash
# Verify PAM configuration
ls /etc/pam.d/hyprlock

# Check user permissions
groups $USER
```

### ⌨️ **Keyboard Layout Issues**

#### AZERTY Shortcuts Not Working
```bash
# Verify keyboard layout
setxkbmap -query

# Check Hyprland input config
grep -A 10 "input {" ~/.config/hypr/hyprland.conf
```

#### Symbol Keys Not Recognized
```bash
# Test key detection
wev  # Wayland event viewer

# Verify AZERTY variant
localectl status
```

### 🔋 **Battery Monitoring Issues**

#### Battery Status Not Detected
```bash
# Check battery path
ls /sys/class/power_supply/

# Test battery script
~/.config/hypr/scripts/battery-monitor.sh status

# Verify battery information
cat /sys/class/power_supply/BAT*/capacity
```

### 🖥️ **Multi-Monitor Problems**

#### Monitors Not Detected
```bash
# List available outputs
hyprctl monitors

# Test manual monitor configuration
hyprctl keyword monitor "HDMI-A-1,1280x1024@60,1920x0,1"

# Check display manager
echo $XDG_SESSION_TYPE  # Should show "wayland"
```

### 🎮 **Performance Issues**

#### High CPU Usage
```bash
# Check running processes
htop

# Disable blur effects temporarily
hyprctl keyword decoration:blur:enabled false

# Reduce animation intensity
hyprctl keyword animations:enabled false
```

#### Lag or Stuttering
```bash
# Check graphics driver
lspci -k | grep -A 2 -E "(VGA|3D)"

# Enable VRR (if supported)
hyprctl keyword misc:vrr 1

# Check refresh rate
hyprctl monitors
```

---

## 📚 **Additional Resources**

### 📖 **Documentation**
- [Official Hyprland Wiki](https://wiki.hyprland.org/)
- [Wayland Protocols](https://wayland.freedesktop.org/docs/html/)
- [SWWW Documentation](https://github.com/Horus645/swww)

### 🛠️ **Development Tools**
- [Hyprland Debug Info](https://wiki.hyprland.org/Crashes-and-Bugs/)
- [Wayland Event Viewer (wev)](https://git.sr.ht/~sircmpwn/wev)
- [Hyprctl Commands](https://wiki.hyprland.org/Configuring/Using-hyprctl/)

### 🎨 **Customization Resources**
- [Hyprland Themes](https://github.com/hyprland-community/awesome-hyprland)
- [Wallpaper Collections](https://github.com/linuxdotexe/nordic-wallpapers)
- [Color Scheme Generators](https://coolors.co/)

### 🏗️ **Related Projects**
- [Waybar Configuration](../waybar/) - Status bar integration
- [Rofi Themes](../rofi/) - Application launcher styling  
- [Alacritty Config](../alacritty/) - Terminal integration

### 💬 **Community Support**
- [Hyprland Discord](https://discord.gg/hQ9XvMUjjr)
- [r/hyprland](https://reddit.com/r/hyprland)
- [Hyprland GitHub Discussions](https://github.com/hyprwm/Hyprland/discussions)

---

## 🏆 **Credits & Acknowledgments**

### 👨‍💻 **Configuration Author**
- **moxer_mmh** - Space Station Hyprland Configuration Suite

### 🙏 **Special Thanks**
- **Hyprland Team** - Amazing Wayland compositor
- **Waybar Contributors** - Excellent status bar
- **SWWW Team** - Beautiful wallpaper management
- **Arch Linux Community** - Package maintenance and support

### 📄 **License**
This configuration is released under the MIT License. Feel free to use, modify, and distribute according to your needs.

---

<div align="center">

**🚀 Welcome to your Space Station! 🚀**

*May your code compile cleanly and your merge conflicts be minimal.*

[![GitHub Stars](https://img.shields.io/github/stars/moxer-mmh/dotfiles?style=social)](https://github.com/moxer-mmh/dotfiles)
[![Last Commit](https://img.shields.io/github/last-commit/moxer-mmh/dotfiles?style=flat-square)](https://github.com/moxer-mmh/dotfiles/commits/main)

</div>
