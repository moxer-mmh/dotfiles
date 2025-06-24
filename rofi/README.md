# 🚀 Rofi Application Launcher Configuration

<div align="center">

![Rofi](https://img.shields.io/badge/Rofi-1.7+-blue?style=for-the-badge&logo=rofi)
![Wayland](https://img.shields.io/badge/Wayland-Compatible-green?style=for-the-badge)
![Themes](https://img.shields.io/badge/Themes-2-purple?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production_Ready-brightgreen?style=for-the-badge)

**Futuristic application launcher themes with cosmic and cyberpunk aesthetics**  
*Space Station cosmic theme • Cyberpunk neon city theme • Professional documentation*

</div>

---

## 📋 **Table of Contents**

- [✨ Overview](#-overview)
- [🎨 Theme Gallery](#-theme-gallery)
- [📁 Configuration Structure](#-configuration-structure)
- [🛠️ Installation](#-installation)
- [🎯 Theme Comparison](#-theme-comparison)
- [⚙️ Usage Examples](#️-usage-examples)
- [🔧 Customization](#-customization)
- [🔗 Integration](#-integration)
- [🐛 Troubleshooting](#-troubleshooting)
- [📚 Additional Resources](#-additional-resources)

---

## ✨ **Overview**

This Rofi configuration provides two professionally designed, futuristic application launcher themes that transform your desktop into a cosmic or cyberpunk environment. Both themes feature modern aesthetics, smooth animations, and excellent usability while maintaining the distinctive visual identity of their respective design philosophies.

### 🌟 **Key Features**

- **🚀 Space Station Theme**: Cosmic nebula colors with electric gradients
- **🌃 Cyberpunk Theme**: Neon city aesthetics with glowing effects
- **🎨 Professional Typography**: JetBrains Mono Nerd Font consistency
- **⚡ Smooth Animations**: CSS-style transitions and hover effects
- **🖼️ Icon Support**: Perfect spacing and alignment for application icons
- **📱 Responsive Design**: Adapts to different screen sizes and resolutions
- **♿ Accessibility**: High contrast and keyboard navigation support
- **🔧 Highly Customizable**: Easy color and layout modifications

---

## 🎨 **Theme Gallery**

### 🚀 **Space Station Theme** (`space-station.rasi`)

<details>
<summary><b>🌌 Cosmic Nebula Design</b></summary>

**Visual Identity:**
- Deep space backgrounds with transparency effects
- Electric purple → cosmic cyan → neon green gradient borders
- Matrix-style neon green text with excellent readability
- Semi-transparent blur effects for depth

**Color Palette:**
| Color | Hex Code | Usage |
|-------|----------|-------|
| **Deep Space** | `#0a0a0f90` | Background base with transparency |
| **Void Darkness** | `#1e1e2e` | Input field backgrounds |
| **Nebula Shadow** | `#2a2a40` | Secondary elements |
| **Neon Green** | `#00ff88` | Primary text (matrix style) |
| **Electric Purple** | `#8844ff` | Accent highlights |
| **Cosmic Cyan** | `#00aaff` | Secondary accents |
| **Neon Pink** | `#ff0088` | Alert highlights |

</details>

### 🌃 **Cyberpunk Theme** (`cyberpunk.rasi`)

<details>
<summary><b>⚡ Neon City Design</b></summary>

**Visual Identity:**
- Dark navy backgrounds with neon glow effects
- Purple-to-cyan gradient selections with box shadows
- High-tech scrollbar design and mode switcher
- Smooth transitions and hover effects

**Color Palette:**
| Color | Hex Code | Usage |
|-------|----------|-------|
| **Dark Navy** | `#1a1a2e` | Background base |
| **Navy Light** | `#16213e` | Input field backgrounds |
| **Neon Green** | `#00ff99` | Borders and active states |
| **Electric Purple** | `#9d4edd` | Primary highlights |
| **Cyber Pink** | `#ff006e` | Urgent notifications |
| **Tech Orange** | `#fb8500` | Warning states |
| **Electric Blue** | `#219ebc` | Information elements |

</details>

---

## 📁 **Configuration Structure**

```
rofi/
├── README.md                    # This comprehensive guide
└── .config/
    └── rofi/
        ├── space-station.rasi   # 🚀 Cosmic nebula theme (358 lines)
        └── cyberpunk.rasi       # 🌃 Neon city theme (465 lines)
```

### 📊 **File Statistics**

| File | Lines | Features | Theme |
|------|-------|----------|--------|
| **space-station.rasi** | 358 | Cosmic colors, blur effects, space aesthetics | 🌌 Space Station |
| **cyberpunk.rasi** | 465 | Neon glows, gradients, scrollbar, mode switcher | 🌃 Cyberpunk |

---

## 🛠️ **Installation**

### 📋 **Prerequisites**

```bash
# Install Rofi (version 1.7+ recommended for full feature support)
# Arch Linux / Manjaro
sudo pacman -S rofi

# Ubuntu / Debian
sudo apt install rofi

# Fedora
sudo dnf install rofi

# Install JetBrains Mono Nerd Font for optimal typography
sudo pacman -S ttf-jetbrains-mono-nerd  # Arch
# Or download from: https://www.nerdfonts.com/font-downloads
```

### 📥 **Installation Methods**

#### Method 1: Using GNU Stow (Recommended)
```bash
# Clone the dotfiles repository
git clone https://github.com/moxer-mmh/dotfiles.git
cd dotfiles

# Backup existing configuration
mv ~/.config/rofi ~/.config/rofi.backup 2>/dev/null || true

# Install with GNU Stow
stow rofi

# Verify installation
ls -la ~/.config/rofi/
```

#### Method 2: Manual Installation
```bash
# Clone repository
git clone https://github.com/moxer-mmh/dotfiles.git
cd dotfiles

# Copy configuration files
mkdir -p ~/.config/rofi
cp rofi/.config/rofi/*.rasi ~/.config/rofi/

# Verify installation
rofi -dump-theme | head -5
```

### 🧪 **Testing Themes**

```bash
# Test Space Station theme
rofi -show drun -theme ~/.config/rofi/space-station.rasi

# Test Cyberpunk theme  
rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi

# Test with icons enabled
rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi -show-icons
```

---

## 🎯 **Theme Comparison**

| Feature | 🚀 Space Station | 🌃 Cyberpunk |
|---------|------------------|--------------|
| **Primary Colors** | Green, Purple, Cyan | Purple, Green, Pink |
| **Background Style** | Semi-transparent space | Solid navy with glow |
| **Visual Effects** | Blur, transparency | Box shadows, gradients |
| **Complexity** | Moderate (358 lines) | Advanced (465 lines) |
| **Best For** | Daily productivity | Gaming, creative work |
| **Scrollbar** | Hidden/minimal | Custom cyberpunk design |
| **Mode Switcher** | Basic | Enhanced with styling |
| **Performance** | Lightweight | Moderate (visual effects) |

### 🎨 **Choosing Your Theme**

**Choose Space Station if you want:**
- Clean, minimalist aesthetic
- Excellent readability
- Fast performance
- Integration with Hyprland cosmic theme

**Choose Cyberpunk if you want:**
- Bold, dramatic visuals
- Advanced visual effects
- Gaming/entertainment setup
- Maximum visual impact

---

## ⚙️ **Usage Examples**

### 🚀 **Application Launcher**
```bash
# Space Station theme
rofi -show drun -theme ~/.config/rofi/space-station.rasi

# Cyberpunk theme with icons
rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi -show-icons

# With custom display format
rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi -drun-display-format "{name}"
```

### 🔄 **Multiple Modes**
```bash
# Combine applications, commands, and SSH
rofi -show combi -theme ~/.config/rofi/space-station.rasi \
     -combi-modi "drun,run,ssh" \
     -show-icons

# Window switcher
rofi -show window -theme ~/.config/rofi/cyberpunk.rasi
```

### 📝 **Custom Menu (dmenu replacement)**
```bash
# Simple menu with cyberpunk styling
echo -e "Option 1\nOption 2\nOption 3" | \
rofi -dmenu -theme ~/.config/rofi/cyberpunk.rasi -p "Choose:"

# File browser
find ~/Documents -type f | \
rofi -dmenu -theme ~/.config/rofi/space-station.rasi -p "Open File:"
```

### 🔋 **Power Menu Example**
```bash
#!/bin/bash
# ~/.local/bin/power-menu
options="🔒 Lock\n⏻ Logout\n⏸ Suspend\n⏹ Hibernate\n↻ Restart\n⏻ Shutdown"
chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -theme ~/.config/rofi/cyberpunk.rasi)

case $chosen in
    "🔒 Lock") swaylock ;;
    "⏻ Logout") hyprctl dispatch exit ;;
    "⏸ Suspend") systemctl suspend ;;
    "⏹ Hibernate") systemctl hibernate ;;
    "↻ Restart") systemctl reboot ;;
    "⏻ Shutdown") systemctl poweroff ;;
esac
```

---

## 🔧 **Customization**

### 🎨 **Color Modifications**

#### Space Station Theme Colors:
```css
/* Edit ~/.config/rofi/space-station.rasi */

// ─── BACKGROUND COLORS ───
bg0: #0a0a0f90;              // Main background (adjust transparency)
bg1: #1e1e2e;                // Input field background
bg2: #2a2a40;                // Secondary elements

// ─── FOREGROUND COLORS ───
fg0: #00ff88;                // Primary text (try #00ffaa for brighter green)
fg1: #8844ff;                // Accent purple (try #aa44ff for brighter)
fg2: #00aaff;                // Accent cyan (try #00ccff for lighter)
```

#### Cyberpunk Theme Colors:
```css
/* Edit ~/.config/rofi/cyberpunk.rasi */

// ─── CYBERPUNK VARIANTS ───
cyan: #00ff99;        // Classic cyan (try #00ffff for electric blue)
purple: #9d4edd;      // Electric purple (try #ff00ff for magenta)
pink: #ff006e;        // Cyber pink (try #ff1493 for hot pink)
```

### 📐 **Layout Adjustments**

```css
/* Window sizing */
window {
    width: 800px;       // Wider for high-res displays (default: 600px)
    height: 500px;      // Taller for more items (cyberpunk: 400px)
}

/* List configuration */
listview {
    lines: 12;          // Show more apps (default: 8)
    columns: 2;         // Two-column layout (default: 1)
}

/* Font scaling */
* {
    font: "JetBrains Mono Nerd Font 16";  // Larger for high-DPI (default: 12-14)
}
```

### 🔍 **Icon Configuration**

```css
/* Icon sizing */
element-icon {
    size: 48px;         // Larger icons (default: 24-32px)
    margin: 0px 12px 0px 0px;  // Adjust spacing
}

/* Enable icons globally */
element {
    orientation: horizontal;  // Icon + text layout
    children: [ element-icon, element-text ];
}
```

---

## 🔗 **Integration**

### 🖥️ **Hyprland Integration**

```bash
# Add to ~/.config/hypr/hyprland.conf

# Space Station launcher (matches cosmic theme)
bind = $mainMod, SPACE, exec, rofi -show drun -theme ~/.config/rofi/space-station.rasi

# Cyberpunk launcher
bind = $mainMod, R, exec, rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi

# Window switcher with theme
bind = ALT, TAB, exec, rofi -show window -theme ~/.config/rofi/space-station.rasi

# Power menu
bind = $mainMod SHIFT, E, exec, ~/.local/bin/power-menu
```

### 📊 **Waybar Integration**

```json
// Add to ~/.config/waybar/config

{
    "custom/launcher": {
        "format": "🚀",
        "tooltip": "Space Station Launcher", 
        "on-click": "rofi -show drun -theme ~/.config/rofi/space-station.rasi"
    },
    "custom/cyberpunk-launcher": {
        "format": "🌃",
        "tooltip": "Cyberpunk Launcher",
        "on-click": "rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi"
    },
    "custom/power": {
        "format": "⏻",
        "tooltip": "Power Menu",
        "on-click": "~/.local/bin/power-menu"
    }
}
```

### 💾 **Default Theme Configuration**

```bash
# Set default theme in ~/.config/rofi/config.rasi
configuration {
    theme: "~/.config/rofi/space-station.rasi";
    show-icons: true;
    display-drun: "🚀 Applications";
    display-run: "⚡ Commands"; 
    display-window: "🪟 Windows";
}
```

### 📱 **Desktop Entry Integration**

```bash
# Create ~/.local/share/applications/rofi-launcher.desktop
cat > ~/.local/share/applications/rofi-launcher.desktop << EOF
[Desktop Entry]
Name=Space Station Launcher
Comment=Cosmic application launcher
Exec=rofi -show drun -theme ~/.config/rofi/space-station.rasi
Icon=application-x-executable
Type=Application
Categories=System;Utility;
EOF
```

---

## 🐛 **Troubleshooting**

### 🔧 **Common Issues**

#### **Themes Not Loading**
```bash
# Check theme file existence
ls -la ~/.config/rofi/*.rasi

# Verify syntax
rofi -dump-theme > /tmp/test.rasi

# Test with absolute path
rofi -show drun -theme /home/$USER/.config/rofi/space-station.rasi

# Check Rofi version (1.7+ recommended)
rofi -version
```

#### **Icons Not Displaying**
```bash
# Install icon theme
sudo pacman -S papirus-icon-theme  # Arch
sudo apt install papirus-icon-theme  # Ubuntu

# Check icon paths
ls /usr/share/icons/

# Test icon support
rofi -show drun -show-icons -theme default

# Rebuild icon cache
sudo gtk-update-icon-cache -f -t /usr/share/icons/*
```

#### **Font Issues**
```bash
# Install JetBrains Mono Nerd Font
sudo pacman -S ttf-jetbrains-mono-nerd

# Rebuild font cache
fc-cache -fv

# Verify font availability
fc-list | grep -i jetbrains

# Test with system font
rofi -show drun -theme ~/.config/rofi/space-station.rasi -font "Sans 12"
```

#### **Visual Effects Not Working**
```bash
# Check compositor support (for blur, shadows)
pgrep -x hyprland  # Hyprland
pgrep -x picom     # Picom for X11

# Disable effects for testing
# Edit theme file and comment out:
# box-shadow: ...
# backdrop-filter: ...

# Check Wayland support
echo $WAYLAND_DISPLAY
rofi -help | grep -i wayland
```

### 🔍 **Debug Mode**

```bash
# Run Rofi in debug mode
rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi -no-config

# Check theme parsing
rofi -dump-theme -theme ~/.config/rofi/space-station.rasi

# Minimal test
rofi -show drun -theme default
```

### 📋 **Performance Issues**

```bash
# Disable visual effects for performance
# In theme file, remove/comment:
# - box-shadow properties
# - backdrop-filter properties  
# - transition properties

# Use simpler theme for low-end systems
rofi -show drun -theme ~/.config/rofi/space-station.rasi  # Lighter than cyberpunk

# Reduce icon size
# In theme: element-icon { size: 16px; }
```

---

## 📚 **Additional Resources**

### 📖 **Official Documentation**
- [Rofi Manual](https://github.com/davatorium/rofi/blob/next/doc/rofi.1.markdown)
- [Rofi Theme Tutorial](https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown)
- [Rofi Configuration](https://github.com/davatorium/rofi/blob/next/doc/rofi.1.markdown#configuration)

### 🎨 **Theme Development**
- [Rofi Theme Reference](https://davatorium.github.io/rofi/current/rofi-theme.5/)
- [Color Scheme Generators](https://coolors.co/)
- [CSS3 Color Names](https://www.w3.org/TR/css-color-3/#x11-color)

### 🔧 **Advanced Configuration**
- [Rofi Scripts Collection](https://github.com/adi1090x/rofi)
- [Custom Modi Development](https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown)
- [Rofi Power Menu Examples](https://github.com/jluttine/rofi-power-menu)

### 🏗️ **Related Projects**
- [Hyprland Configuration](../hypr/) - Window manager integration
- [Waybar Configuration](../waybar/) - Status bar integration
- [Alacritty Configuration](../alacritty/) - Terminal integration

### 🎮 **Theme Collections**
- [Nord Rofi Theme](https://github.com/undiabler/nord-rofi-theme)
- [Material Rofi Themes](https://github.com/lr-tech/rofi-themes-collection)
- [Awesome Rofi](https://github.com/davatorium/rofi/wiki/User-scripts)

### 💬 **Community Support**
- [Rofi GitHub Discussions](https://github.com/davatorium/rofi/discussions)
- [r/unixporn](https://reddit.com/r/unixporn) - Theme showcase
- [r/i3wm](https://reddit.com/r/i3wm) - Window manager community

---

## 🏆 **Credits & Acknowledgments**

### 👨‍💻 **Configuration Author**
- **moxer_mmh** - Space Station & Cyberpunk Rofi Theme Suite

### 🙏 **Special Thanks**
- **Rofi Development Team** - Excellent application launcher framework
- **JetBrains** - Outstanding monospace typography with Nerd Font support
- **Hyprland Community** - Wayland compositor inspiration and integration
- **Cyberpunk & Space Fiction Communities** - Aesthetic inspiration and color theory

### 🎨 **Design Inspiration**
- **Blade Runner 2049** - Cyberpunk neon aesthetics
- **The Matrix** - Green digital rain and interface design
- **Interstellar** - Space station cosmic themes
- **GitHub Dark Theme** - Professional dark interface patterns

### 📄 **License**
This configuration is released under the MIT License. Feel free to use, modify, and distribute according to your needs.

---

<div align="center">

**🚀 Launch into the future with style! 🌃**

*Whether you choose the cosmic depths of space or the neon lights of the cyberpunk city,  
your application launcher will be a gateway to digital excellence.*

[![GitHub Stars](https://img.shields.io/github/stars/moxer-mmh/dotfiles?style=social)](https://github.com/moxer-mmh/dotfiles)
[![Last Commit](https://img.shields.io/github/last-commit/moxer-mmh/dotfiles?style=flat-square)](https://github.com/moxer-mmh/dotfiles/commits/main)

</div>
