# 🌌 Cosmic Space Station Dotfiles

<div align="center">

![Linux](https://img.shields.io/badge/OS-Linux-blue?style=for-the-badge&logo=linux)
![Wayland](https://img.shields.io/badge/Wayland-Compatible-green?style=for-the-badge)
![Theme](https://img.shields.io/badge/Theme-Cosmic%20Nebula-purple?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=for-the-badge)

**🚀 A complete cyberpunk-cosmic themed development environment for Linux 🚀**

*Professional dotfiles featuring cosmos/nebula/cyberpunk space station aesthetics*
*Hyprland • Waybar • Alacritty • Rofi • Starship • Zsh*

</div>

---

## ✨ **Features Overview**

### 🎨 **Cosmic Visual Identity**

- **🌌 Deep Space Aesthetics**: Nebula backgrounds with electric purple → cosmic cyan → neon green gradients
- **⚡ Neon Cyberpunk Accents**: Matrix-inspired green text with hot pink highlights
- **🔮 Transparency & Blur**: Modern depth effects with backdrop blur and layered opacity
- **🎭 Consistent Iconography**: Space station themes across all applications
- **✨ Smooth Animations**: Cosmic bezier curves and space-themed transitions

### 🖥️ **Professional Window Management**

- **🚀 Hyprland Wayland Compositor**: GPU-accelerated with cosmic animations
- **🖼️ Dual Monitor Support**: 1920x1080@144Hz + 1280x1024@60Hz optimized setup
- **⌨️ AZERTY Layout Optimized**: French keyboard layout with development-focused shortcuts
- **🌅 Dynamic Wallpapers**: Automatic cosmic wallpaper cycling with smooth transitions
- **🔒 Intelligent Power Management**: Battery-aware idle states and secure lock screen

### 🎮 **Cosmic Control Center**

- **📊 Waybar Status Bar**: Space station control panel with system monitoring
- **🚀 Rofi Application Launcher**: Cyberpunk and space station themed menus
- **🐲 Starship Prompt**: Cross-shell cosmic dragon prompt with language detection
- **📋 Smart Clipboard Manager**: Persistent clipboard history with text and image support
- **🌊 Seamless Integration**: All components work together harmoniously

### 💻 **Development Environment**

- **⚡ Alacritty Terminal**: High-performance GPU-accelerated with cosmic transparency
- **🔤 JetBrains Mono Nerd Font**: Consistent typography with programming ligatures
- **🐚 Enhanced Zsh Shell**: Oh My Zsh framework with modern CLI tool replacements
- **🎯 Developer-Focused**: Optimized for coding workflows and system administration

---

## � **Cosmic Color Palette**

| Component                  | Primary Colors            | Accent Colors               | Status Colors              |
| -------------------------- | ------------------------- | --------------------------- | -------------------------- |
| **🌌 Space Station** | Deep Space `#0a0a0f`    | Electric Purple `#8844ff` | Success Green `#00ff88`  |
| **⚡ Cyberpunk**     | Dark Navy `#1a1a2e`     | Neon Cyan `#00bfff`       | Warning Orange `#ffa500` |
| **🔮 Cosmic**        | Nebula Purple `#1e0c44` | Hot Pink `#ff69b4`        | Critical Red `#ff4500`   |

### Visual Harmony

All components share the same cosmic DNA:

- **Background**: Deep space blacks with transparency
- **Text**: Matrix neon green for optimal readability
- **Accents**: Purple-cyan gradients with pink highlights
- **Status**: Color-coded feedback for instant recognition

---

## 📋 **System Requirements**

### 🔧 **Core Dependencies**

```bash
# Arch Linux / Manjaro (recommended)
sudo pacman -S hyprland hypridle hyprlock waybar alacritty rofi starship zsh
sudo pacman -S swww swaync brightnessctl playerctl

# Audio system (PipeWire)
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pavucontrol wireplumber

# Clipboard management
sudo pacman -S cliphist wl-clipboard

# System dependencies
sudo pacman -S ttf-jetbrains-mono-nerd stow git

# Enhanced CLI tools
sudo pacman -S lsd bat neovim oh-my-zsh-git

# Optional development tools
sudo pacman -S code brave-browser spotify-launcher nautilus
```

### 📦 **Component Versions**

- **Hyprland**: 0.41+
- **Waybar**: 0.9.24+
- **Alacritty**: 0.13+
- **Rofi**: 1.7+
- **Starship**: 1.16+
- **Zsh**: 5.8+

### 🎮 **Hardware Recommendations**

- **GPU**: Support for Wayland compositor (Intel/AMD/NVIDIA)
- **RAM**: 8GB+ for smooth animations and multiple monitors
- **Display**: Any resolution (optimized for dual monitor setups)

---

## � **Installation**

### 📥 **Method 1: Quick Setup (Recommended)**

```bash
# 1. Clone the cosmic repository
git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Install system dependencies (see requirements above)

# 3. Backup existing configurations (safety first!)
mkdir -p ~/.config/backup/$(date +%Y%m%d_%H%M%S)
for app in alacritty hypr rofi starship waybar zsh; do
    [ -d ~/.config/$app ] && cp -r ~/.config/$app ~/.config/backup/$(date +%Y%m%d_%H%M%S)/
done

# 4. Deploy the cosmic configuration
stow alacritty
stow hypr  
stow rofi
stow starship
stow waybar
stow zsh

# 5. Make scripts executable
chmod +x ~/.config/hypr/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh

# 6. Launch the space station!
# Log out and select Hyprland from your display manager
```

### 📋 **Method 2: Selective Installation**

Install only specific components:

```bash
cd ~/dotfiles

# Essential cosmic components
stow alacritty    # 🚀 Cosmic terminal
stow hypr         # 🌌 Window manager with space station scripts
stow waybar       # 📊 Status bar with cosmic modules

# Enhanced user experience  
stow rofi         # 🎮 Application launcher themes
stow starship     # 🐲 Cosmic dragon shell prompt
stow zsh          # 🐚 Enhanced shell with modern tools
```

### 🔄 **Method 3: Traditional Symlinks**

```bash
# Manual symlink creation (for advanced users)
ln -sf ~/dotfiles/alacritty/.config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/hypr/.config/hypr ~/.config/hypr
ln -sf ~/dotfiles/waybar/.config/waybar ~/.config/waybar
ln -sf ~/dotfiles/rofi/.config/rofi ~/.config/rofi
ln -sf ~/dotfiles/starship/.config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```

---

## 🎯 **Component Documentation**

Each component has detailed documentation with installation guides, customization options, and troubleshooting:

| Component                                  | Features                                                       | Documentation                                           |
| ------------------------------------------ | -------------------------------------------------------------- | ------------------------------------------------------- |
| **🚀 [Alacritty](alacritty/README.md)** | GPU-accelerated terminal, cosmic transparency, 50% opacity     | Terminal setup, color schemes, performance tuning       |
| **🌌 [Hyprland](hypr/README.md)**       | Wayland compositor, dual monitors, AZERTY optimized            | Window management, animations, scripts, troubleshooting |
| **🎮 [Rofi](rofi/README.md)**           | Space Station & Cyberpunk themes, smooth animations            | Theme comparison, customization, integration guides     |
| **🐲 [Starship](starship/README.md)**   | Cosmic dragon prompt, language detection, performance tracking | Prompt customization, shell integration, configuration  |
| **📊 [Waybar](waybar/README.md)**       | Cosmic status bar, system monitoring, audio controls           | Module configuration, styling, scripts, integration     |
| **� [Zsh](zsh/README.md)**             | Oh My Zsh framework, enhanced CLI tools, aliases               | Shell setup, productivity features, customization       |

---

## ⚙️ **Essential Configuration**

### 🖼️ **Wallpaper Setup**

```bash
# Create wallpaper directory for automatic cycling
mkdir -p ~/Pictures/Wallpapers

# Add your cosmic wallpapers (JPG, JPEG, PNG supported)
# Wallpapers will automatically cycle every 30 seconds

# Test wallpaper system
~/.config/hypr/scripts/wallpaper-cycle.sh
```

### 🔤 **Font Configuration**

```bash
# Install JetBrains Mono Nerd Font (required for icons)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv

# Verify font installation
fc-list | grep -i jetbrains
```

### 🐚 **Shell Setup**

```bash
# Change default shell to Zsh
chsh -s $(which zsh)

# Install Oh My Zsh (if not already installed)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Start new shell session
exec zsh
```

---

## 🔧 **Customization Guide**

### 🎨 **Changing Colors**

**Global color modifications:**

```bash
# Primary cosmic colors in Waybar
edit ~/.config/waybar/style.css
# Look for: --deep-space, --electric-purple, --neon-cyan

# Terminal colors in Alacritty  
edit ~/.config/alacritty/alacritty.toml
# Look for: [colors] section

# Rofi theme colors
edit ~/.config/rofi/space-station.rasi  # or cyberpunk.rasi
# Look for: color definitions at top of file
```

### 🌅 **Adding Wallpapers**

```bash
# Add new cosmic wallpapers
cp your-space-wallpapers/* ~/Pictures/Wallpapers/

# Wallpapers will automatically cycle
# To force immediate change:
~/.config/hypr/scripts/wallpaper-cycle.sh
```

### ⌨️ **Keybinding Modifications**

```bash
# Edit Hyprland keybindings
edit ~/.config/hypr/hyprland.conf
# Look for: bind = sections

# Common customizations:
# - Change $mainMod (default: Super key)
# - Add application shortcuts
# - Modify workspace navigation
```

### 🎭 **Theme Switching**

```bash
# Switch Rofi themes
rofi -show drun -theme ~/.config/rofi/space-station.rasi  # Cosmic theme
rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi     # Cyberpunk theme

# Make permanent by editing Hyprland config:
# bind = $mainMod, Space, exec, rofi -show drun -theme ~/.config/rofi/cyberpunk.rasi
```

---

## 🔗 **Integration & Workflow**

### 🚀 **Development Workflow**

```bash
# Quick development session
Super + Enter          # Launch Alacritty terminal
Super + C              # Open VS Code
Super + B              # Launch Brave browser
Super + Space           # Rofi application launcher

# Git workflow (with Oh My Zsh git plugin)
gst                    # git status
gco main               # git checkout main  
ga .                   # git add .
gcmsg "commit message" # git commit -m
```

### 📊 **System Monitoring**

```bash
# Waybar modules show real-time info:
# - CPU usage with click-to-htop
# - Memory monitoring  
# - Battery status with health optimization
# - Audio controls with mute indicators
# - Camera privacy status
# - Network connection state
```

### 🎵 **Media Controls**

```bash
# Waybar Spotify integration:
# Left click: Play/pause
# Right click: Next track
# Scroll: Volume control

# Audio controls:
# Click: Open pavucontrol
# Right click: Toggle mute
# Scroll: Adjust volume
```

---

## 📁 **Project Structure**

```
dotfiles/
├── 🚀 alacritty/          # Cosmic terminal configuration
│   ├── README.md           # Terminal documentation
│   └── .config/alacritty/
│       └── alacritty.toml  # Color scheme, transparency, font
│
├── 🌌 hypr/               # Hyprland window manager  
│   ├── README.md           # WM documentation
│   └── .config/hypr/
│       ├── hyprland.conf   # Main compositor config
│       ├── hyprlock.conf   # Cosmic lock screen
│       ├── hypridle.conf   # Power management
│       └── scripts/        # Space station automation
│           ├── space-station-startup.sh
│           ├── wallpaper-cycle.sh
│           ├── battery-monitor.sh
│           └── camera-toggle.sh
│
├── 🎮 rofi/               # Application launcher themes
│   ├── README.md           # Launcher documentation  
│   └── .config/rofi/
│       ├── space-station.rasi    # Cosmic nebula theme
│       └── cyberpunk.rasi        # Neon city theme
│
├── 🐲 starship/           # Cross-shell cosmic prompt
│   ├── README.md           # Prompt documentation
│   └── .config/
│       └── starship.toml   # Dragon prompt configuration
│
├── 📊 waybar/             # Space station status bar
│   ├── README.md           # Status bar documentation
│   └── .config/waybar/
│       ├── config.jsonc    # Module configuration
│       ├── style.css       # Cosmic styling
│       └── scripts/
│           └── camera.sh   # Camera privacy monitoring
│
├── 🐚 zsh/                # Enhanced shell configuration
│   ├── README.md           # Shell documentation
│   └── .zshrc              # Zsh configuration with aliases
│
├── 📄 README.md            # This cosmic guide
├── 📄 LICENSE              # MIT License
└── 📄 Makefile             # Automation scripts
```

---

## 🐛 **Troubleshooting**

### 🔧 **Common Issues**

**Hyprland won't start:**

```bash
# Check logs for errors
journalctl --user -u hyprland

# Verify dependencies
hyprland --version
waybar --version
```

**Missing icons/fonts:**

```bash
# Reinstall Nerd Fonts
sudo pacman -S ttf-jetbrains-mono-nerd
fc-cache -fv

# Verify font installation
fc-list | grep -i nerd
```

**Waybar not displaying:**

```bash
# Check configuration syntax
waybar --log-level debug

# Test individual modules
~/.config/waybar/scripts/camera.sh
```

**Rofi themes not working:**

```bash
# Test theme syntax
rofi -show drun -theme ~/.config/rofi/space-station.rasi

# Check font dependencies
fc-list | grep -i jetbrains
```

### 📚 **Getting Help**

- **Component-specific issues**: Check individual README files
- **Configuration problems**: Each component has troubleshooting sections
- **Font issues**: Ensure JetBrains Mono Nerd Font is properly installed
- **Performance issues**: Check system requirements and reduce transparency

---

## 🤝 **Contributing**

Feel free to contribute to the cosmic journey:

### 🌟 **Ways to Contribute**

- **🐛 Bug Reports**: Found an issue? Open an issue with details
- **✨ Feature Requests**: Ideas for new cosmic features
- **🎨 Theme Variations**: Share your color scheme modifications
- **📚 Documentation**: Improve guides and add examples
- **🚀 New Components**: Add support for additional applications

### 📋 **Contribution Guidelines**

1. **Fork the repository** and create a feature branch
2. **Test your changes** thoroughly across different setups
3. **Update documentation** for any new features
4. **Follow the cosmic theme** aesthetic and naming conventions
5. **Submit a pull request** with detailed description

---

## 📜 **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

Feel free to use, modify, and distribute these configurations for your own cosmic journey!

---

## 🌟 **Inspiration & Credits**

This cosmic configuration draws inspiration from:

- **🌌 Deep Space & Nebula Imagery**: Hubble Space Telescope photos
- **⚡ Cyberpunk Aesthetics**: Neon colors and futuristic interfaces
- **🚀 Sci-Fi User Interfaces**: Space station control panels
- **💻 Development Workflows**: Optimized for programming productivity
- **🎭 Modern Linux Theming**: Contemporary design principles

### 🎯 **Special Thanks**

- **Hyprland community** for the amazing Wayland compositor
- **Waybar developers** for the flexible status bar
- **Starship team** for the cross-shell prompt
- **JetBrains** for the excellent Mono font
- **Nerd Fonts project** for programming font icons

---

<div align="center">

# 🚀 **Welcome to the Space Station** 🚀

**⚡ May your code compile faster than the speed of light! ⚡**

*Enjoy your cosmic development journey across the digital universe*

</div>
