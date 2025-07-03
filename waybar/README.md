# 🚀 Space Station Waybar Configuration

<div align="center">

![Waybar](https://img.shields.io/badge/Status%20Bar-Waybar-blue?style=for-the-badge&logo=waybar)
![Theme](https://img.shields.io/badge/Theme-Cosmic%20Nebula-purple?style=for-the-badge)
![Compositor](https://img.shields.io/badge/Compositor-Hyprland-cyan?style=for-the-badge)

*A futuristic status bar with cosmic gradients, neon highlights, and cyberpunk aesthetics*

</div>

## ✨ Features

### 🎨 **Cosmic Visual Design**

- **Nebula Gradients**: Purple-cyan-pink color scheme with layered depth
- **Neon Glow Effects**: Dynamic hover states with multi-layer shadows
- **Responsive Animations**: Smooth transitions and cubic-bezier curves
- **Semi-Transparent Blur**: Modern depth effects with backdrop blur

### 📊 **System Monitoring**

- **Workspace Indicators**: Visual feedback for active, urgent, and inactive workspaces
- **Audio Controls**: Speaker and microphone status with mute indicators
- **Network Status**: Connection state visualization with color coding
- **System Performance**: CPU, memory, and temperature monitoring
- **Battery Management**: Charge level indicators with charging animations

### 🔧 **Developer Features**

- **JetBrains Mono Font**: Consistent developer typography with Nerd Font icons
- **Window Title Display**: Current focused application with italicized styling
- **System Tray Integration**: Application icons with attention states
- **Custom Modules**: Function keys, camera status, and Spotify integration

## 🎯 Color Palette

### Primary Colors

```css
Deep Space Purple:  #10042A (16, 4, 42)     /* Primary background */
Nebula Purple:      #1E0C44 (30, 12, 68)    /* Secondary background */
Cosmic Purple:      #2D1955 (45, 25, 85)    /* Accent background */
```

### Accent Colors

```css
Electric Purple:    #8A2BE2 (138, 43, 226)  /* Primary accent */
Neon Cyan:         #00BFFF (0, 191, 255)    /* Secondary accent */
Matrix Green:      #00FF7F (0, 255, 127)    /* Success states */
Hot Pink:          #FF69B4 (255, 105, 180)  /* Clock emphasis */
```

### Status Colors

```css
Warning Orange:    #FFA500 (255, 165, 0)    /* Warning states */
Critical Red:      #FF4500 (255, 69, 0)     /* Error states */
Spotify Green:     #1ED760 (30, 215, 96)    /* Music integration */
```

## 📋 Prerequisites

### Required Dependencies

1. **Waybar** (version 0.9.24+)

   ```bash
   # Ubuntu/Debian
   sudo apt install waybar

   # Arch Linux
   sudo pacman -S waybar

   # Fedora
   sudo dnf install waybar
   ```
2. **JetBrains Mono Nerd Font**

   ```bash
   # Download and install from Nerd Fonts
   wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
   unzip JetBrainsMono.zip -d ~/.local/share/fonts/
   fc-cache -fv
   ```
3. **Hyprland** (recommended compositor)

   ```bash
   # Arch Linux
   sudo pacman -S hyprland

   # Or install from AUR for latest version
   yay -S hyprland-git
   ```

### Optional Dependencies

- **Audio Control**: `pipewire`, `pipewire-pulse`, `pavucontrol`, `wireplumber`
- **Music Integration**: `playerctl`, `spotify`
- **System Monitoring**: `lm-sensors`, `htop`
- **Camera Detection**: `v4l2-ctl`, `lsof`
- **GNU Stow**: For dotfiles management

## 🚀 Installation

### Method 1: Using GNU Stow (Recommended)

1. **Clone the dotfiles repository**:

   ```bash
   git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. **Backup existing configuration** (if any):

   ```bash
   mv ~/.config/waybar ~/.config/waybar.backup 2>/dev/null || true
   ```
3. **Install using GNU Stow**:

   ```bash
   # From the dotfiles directory
   stow waybar
   ```
4. **Make scripts executable**:

   ```bash
   chmod +x ~/.config/waybar/scripts/*.sh
   ```
5. **Verify installation**:

   ```bash
   ls -la ~/.config/waybar
   waybar --version
   ```

### Method 2: Manual Installation

1. **Clone and copy files**:
   ```bash
   git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
   mkdir -p ~/.config/waybar
   cp -r ~/dotfiles/waybar/.config/waybar/* ~/.config/waybar/
   chmod +x ~/.config/waybar/scripts/*.sh
   ```

### Method 3: Direct Symlink

1. **Create symbolic link**:
   ```bash
   # Backup existing config
   mv ~/.config/waybar ~/.config/waybar.backup 2>/dev/null || true

   # Create symbolic link
   ln -sf ~/dotfiles/waybar/.config/waybar ~/.config/waybar
   chmod +x ~/.config/waybar/scripts/*.sh
   ```

## 📁 File Structure

```
waybar/
├── README.md                           # This documentation
├── .config/
│   └── waybar/
│       ├── config.jsonc                # Main Waybar configuration
│       ├── style.css                   # Cosmic theme styling
│       └── scripts/
│           └── camera.sh               # Camera status monitoring
```

## ⚙️ Configuration

### Module Layout

**Left Section**: `[Workspaces] [Window Title]`

- Workspace navigation with cosmic icons
- Current focused window display

**Center Section**: `[Digital Clock with Calendar]`

- 24-hour time format with calendar popup
- Cosmic-styled date display on alt-click

**Right Section**: `[Spotify] [Audio] [Mic] [Camera] [Tray] [CPU] [Memory] [Temp] [Battery]`

- System monitoring and control modules
- Audio controls with mute indicators
- Custom modules for enhanced functionality

### Workspace Icons

| Workspace | Icon | Purpose              |
| --------- | ---- | -------------------- |
| 1         | 󰆍   | Terminal/Development |
| 2         | 󰖟   | Web Browser          |
| 3         | 󰘦   | Communication        |
| 4         | 󰓓   | Media/Graphics       |
| 5         | 󰑴   | Files/Documents      |
| 6         | 󰊻   | Gaming               |
| 7         | 󰎄   | Virtualization       |
| 8         | 󰛖   | System Monitoring    |
| 9         | 󰺵   | Testing/Experimental |
| 10        | 󰿉   | Utilities            |

## 🎮 Usage

### Module Interactions

#### **Audio Controls**

- **Left Click**: Open volume control (PipeWire/PulseAudio compatible)
- **Right Click**: Toggle mute
- **Scroll**: Adjust volume (±2% for microphone)

#### **Spotify Integration**

- **Left Click**: Play/pause toggle
- **Right Click**: Next track
- **Scroll Up**: Volume +10%
- **Scroll Down**: Volume -10%

#### **System Monitoring**

- **CPU/Memory**: Click to open htop
- **Camera**: Click to open camera app
- **Battery**: Hover for detailed charge info

#### **Workspace Navigation**

- **Left Click**: Switch to workspace
- **Scroll**: Navigate through workspaces
- **Visual States**: Active (bright), urgent (pulsing), inactive (dimmed)

### Status Indicators

#### **Camera Module**

- 🟢 **Green** (󰄀): Camera available and ready
- 🟡 **Yellow** (󰄁): Camera actively recording/in use
- 🔴 **Red** (󰖠): Camera disabled or unavailable
- ⚫ **Gray** (󰄀): Unknown state

#### **Battery Module**

- **Green**: Healthy charge (>30%)
- **Gold**: Charging state with pulse animation
- **Orange**: Low battery warning (≤30%)
- **Red**: Critical battery (≤15%) with flash

#### **Audio Module**

- **Gold**: Normal audio output
- **Red**: Audio muted
- **Cyan**: Microphone active
- **Orange**: Microphone muted (with flash)

## 🔧 Customization

### Changing Colors

Edit the color palette in `style.css`:

```css
/* Primary colors */
--deep-space: #10042A;
--electric-purple: #8A2BE2;
--neon-cyan: #00BFFF;
--matrix-green: #00FF7F;
```

### Adding Custom Modules

1. **Create module script**:

   ```bash
   touch ~/.config/waybar/scripts/custom-module.sh
   chmod +x ~/.config/waybar/scripts/custom-module.sh
   ```
2. **Add to configuration** in `config.jsonc`:

   ```jsonc
   "custom/module": {
       "format": "{}",
       "exec": "~/.config/waybar/scripts/custom-module.sh",
       "interval": 5
   }
   ```
3. **Style in CSS**:

   ```css
   #custom-module {
       color: #00BFFF;
       border-color: rgba(0, 191, 255, 0.3);
   }
   ```

### Adjusting Update Intervals

Modify intervals in `config.jsonc` for performance:

```jsonc
{
    "cpu": {
        "interval": 5,  // Reduce from 2 seconds
        "format": "󰻠 {usage}%"
    }
}
```

### Transparency and Effects

Adjust transparency in `style.css`:

```css
window#waybar {
    background: linear-gradient(135deg,
        rgba(16, 4, 42, 0.95) 0%,    /* Change 0.95 to desired opacity */
        /* ... */
    );
}
```

## 🔗 Integration

### Hyprland Integration

Add to `~/.config/hypr/hyprland.conf`:

```bash
# Auto-start waybar
exec-once = waybar

# Waybar toggle keybinding
bind = $mainMod, B, exec, pkill waybar || waybar

# Workspace bindings (for waybar workspace switching)
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
# ... (continue for all workspaces)
```

### Systemd Service (Optional)

Create `~/.config/systemd/user/waybar.service`:

```ini
[Unit]
Description=Waybar status bar
Documentation=https://github.com/Alexays/Waybar
PartOf=hyprland-session.target

[Service]
ExecStart=/usr/bin/waybar
Restart=on-failure
RestartSec=1

[Install]
WantedBy=hyprland-session.target
```

Enable service:

```bash
systemctl --user enable waybar.service
systemctl --user start waybar.service
```

## 🐛 Troubleshooting

### Common Issues

**Waybar not starting**:

```bash
# Check configuration syntax
waybar --log-level debug

# Validate JSON configuration
jsonlint ~/.config/waybar/config.jsonc
```

**Missing icons**:

```bash
# Install Nerd Fonts
yay -S ttf-nerd-fonts-symbols

# Update font cache
fc-cache -fv

# Verify font installation
fc-list | grep -i jetbrains
```

**CSS not applying**:

```bash
# Check CSS syntax (install csslint if needed)
npm install -g csslint
csslint ~/.config/waybar/style.css

# Reload waybar
pkill waybar && waybar &
```

**Module not displaying**:

```bash
# Check module dependencies
which playerctl  # For Spotify module
which sensors    # For temperature module
which lsof       # For camera module

# Test module command directly
~/.config/waybar/scripts/camera.sh
```

### Performance Optimization

**Reduce animation overhead**:

```css
/* Disable animations for performance */
* {
    transition: none !important;
    animation: none !important;
}
```

**Optimize script execution**:

```bash
# Increase script intervals in config.jsonc
"interval": 10  # Instead of 1-2 seconds
```

## 🎛️ Keyboard Shortcuts

| Shortcut                 | Action                   |
| ------------------------ | ------------------------ |
| `Super + 1-10`         | Switch to workspace      |
| `Super + Shift + 1-10` | Move window to workspace |

## 📚 Scripts Documentation

### Camera Status Script (`camera.sh`)

**Features**:

- Real-time camera detection and status monitoring
- F6 function key state tracking
- USB camera hardware presence detection
- Process usage monitoring via lsof
- Detailed tooltip information

**Usage**:

```bash
./camera.sh status    # Get status icon
./camera.sh tooltip   # Get detailed info
```

**Dependencies**:

- `v4l2-ctl`: Video device control
- `lsof`: Process monitoring
- `lsusb`: USB device detection

## 🛠️ Stow Management Commands

```bash
# Update configuration
cd ~/dotfiles
git pull
stow -R waybar  # Restow to apply changes

# Uninstall
stow -D waybar

# Check what would be stowed
stow -n -v waybar
```

## 📚 Additional Resources

### Documentation

- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki) - Official documentation
- [CSS Styling Guide](https://github.com/Alexays/Waybar/wiki/Styling) - Theme customization
- [Module Reference](https://github.com/Alexays/Waybar/wiki/Modules) - Available modules

### Related Projects

- [Hyprland](https://hyprland.org/) - Wayland compositor integration
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) - Font used in theme
- [Nerd Fonts](https://www.nerdfonts.com/) - Icon font collection

### Community

- [r/unixporn](https://reddit.com/r/unixporn) - Desktop customization
- [Waybar Themes](https://github.com/topics/waybar-theme) - Community themes
- [Hyprland Discord](https://discord.gg/hQ9XvMUjjr) - Support community

## 🤝 Contributing

### Reporting Issues

- Check existing issues in the dotfiles repository
- Provide waybar version and error logs
- Include relevant system information

### Submitting Improvements

- Fork the repository
- Test changes thoroughly
- Follow existing code style and documentation format
- Submit pull request with clear description

## 📄 License

This configuration is part of the Space Station development environment dotfiles collection. Feel free to use, modify, and share.

---

<div align="center">

**Space Station Development Environment** | Cosmic-themed productivity suite
*Enhancing your development workflow with futuristic aesthetics* ⭐

</div>
