# 🌌 Cosmic Space Station Dotfiles

> **A complete cyberpunk-cosmic themed development environment for Linux**

Personal configuration files featuring a **cosmos/nebula/interstellar/cyberpunk space station** aesthetic. This setup creates a cohesive cosmic development environment with neon accents, space themes, and professional functionality.

## ⭐ Features

### 🎨 **Cosmic Theme**

- **Deep space backgrounds** with cosmic purple/green neon accents
- **Consistent cosmic iconography** across all applications
- **JetBrainsMonoNL Nerd Font** for perfect terminal typography
- **Space station startup scripts** with cosmic boot sequence

### 🖥️ **Window Management**

- **Hyprland** - Wayland compositor with cosmic animations
- **Dual monitor support** (1920x1080@144Hz + 1280x1024@60Hz)
- **AZERTY keyboard layout** optimized keybindings
- **Cosmic wallpaper cycling** via SWWW daemon

### 🎮 **Status & Launchers**

- **Waybar** - Space station control panel with cosmic modules
- **Rofi** - Cyberpunk application launcher

### 💻 **Development Environment**

- **Neovim** - Cosmic code editor with Lazy.nvim plugin manager
- **Alacritty** - Transparent terminal with cosmic color scheme
- **VS Code** - Backup editor with cosmic extensions

### 🎵 **System Integration**

- **PulseAudio** - Audio with cosmic controls
- **GRUB** - Custom cosmic boot themes (Cyberpunk/CyberRe/Starfield)
- **GTK** - System theming integration
- **Starship** - Cosmic shell prompt

## 📋 Requirements

### System Dependencies

```bash
# Arch Linux
sudo pacman -S hyprland hypridle hyprlock waybar alacritty neovim rofi swaync
sudo pacman -S swww wlsunset brightnessctl pavucontrol
sudo pacman -S ttf-jetbrains-mono-nerd stow git

# Additional tools
sudo pacman -S nautilus btop nm-applet tray blueman-applet
```

## 🛠️ Installation

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install using the Makefile
make install

# Or manual setup with stow
```

### Manual Installation

```bash
# Install stow if not available
sudo pacman -S stow

# Backup existing configurations (recommended)
make backup

# Symlink configurations
stow alacritty
stow nvim  
stow hypr
stow waybar
stow rofi
stow starship
stow zsh
stow gtk
stow Code
stow btop
stow pavucontrol
```

## 🔧 Customization

### Changing Themes

```bash
# Update wallpapers
cp your-space-wallpapers/* ~/Pictures/Wallpapers/

# Modify cosmic colors
edit waybar/.config/waybar/style.css
edit alacritty/.config/alacritty/alacritty.toml
```

### Adding New Configurations

```bash
# Create new module
mkdir new-app
mkdir new-app/.config/new-app
# Add your configs...
stow new-app
```

## 🚀 Space Station Scripts

The setup includes cosmic automation scripts:

- `space-station-startup.sh` - Cosmic boot sequence
- `wallpaper-cycle.sh` - Automatic wallpaper rotation
- `battery-monitor.sh` - Power management
- `camera-toggle.sh` - Privacy camera controls

## 📁 Project Structure

```
dotfiles/
├── alacritty/          # Terminal configuration
├── btop/               # System monitor
├── Code/               # VS Code settings  
├── grub/               # Boot themes
│   └── themes/
│       ├── Cyberpunk/
│       ├── CyberRe/
│       └── starfield/
├── gtk/                # GTK theming
├── hypr/               # Hyprland WM
│   └── scripts/        # Space station automation
├── nvim/               # Neovim configuration
├── pavucontrol/        # Audio control
├── rofi/               # Application launcher
├── starship/           # Shell prompt
├── waybar/             # Status bar
├── zsh/                # Shell configuration
├── Makefile            # Automation tasks
├── README.md           # This file
└── .gitignore          # Git ignore rules
```

## 🤝 Contributing

Feel free to:

- Submit issues for bugs or suggestions
- Create pull requests for improvements
- Share your cosmic theme variations
- Add new space station features

## 📜 License

MIT License - Feel free to customize and share your cosmic journey!

## 🌟 Inspiration

This configuration draws inspiration from:

- Cyberpunk aesthetics and neon colors
- Deep space and nebula imagery
- Development workflows
- Sci-fi user interfaces and space stations

---

**⚡ May your code compile faster than the speed of light! 🚀**
