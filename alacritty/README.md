# 🚀 Alacritty Terminal Configuration

<div align="center">

![Alacritty](https://img.shields.io/badge/Terminal-Alacritty-orange?style=for-the-badge&logo=alacritty)
![Theme](https://img.shields.io/badge/Theme-Cosmic%20Nebula-purple?style=for-the-badge)
![Font](https://img.shields.io/badge/Font-JetBrains%20Mono-blue?style=for-the-badge)

*A cosmic-themed terminal experience with perfect transparency and neon aesthetics*

</div>

## ✨ Features

- **🌌 Cosmic Nebula Theme**: Custom color scheme inspired by space and cyberpunk aesthetics
- **🔍 Perfect Transparency**: 50% opacity for a modern, layered desktop experience
- **⚡ High Performance**: GPU-accelerated rendering with Alacritty's speed
- **🎨 Nerd Font Support**: JetBrains Mono Nerd Font for icons and excellent readability
- **⌨️ AZERTY Optimized**: Keyboard shortcuts optimized for AZERTY layouts
- **🖱️ Enhanced Mouse Support**: Unix-style selection and pasting
- **📚 Extensive Scrollback**: 10,000 lines of terminal history

## 🎨 Color Palette

### Primary Colors

| Color      | Hex Code    | Usage                           |
| ---------- | ----------- | ------------------------------- |
| Background | `#0a0a0f` | Deep space black with blue tint |
| Foreground | `#00ff88` | Bright neon green text          |

### ANSI Colors

| Color   | Normal      | Bright      | Description        |
| ------- | ----------- | ----------- | ------------------ |
| Black   | `#1e1e2e` | `#2a2a40` | Soft grays         |
| Red     | `#ff0088` | `#ff4488` | Hot pink/magenta   |
| Green   | `#00ff88` | `#44ff88` | Neon green         |
| Yellow  | `#ffaa00` | `#ffcc44` | Warm orange-yellow |
| Blue    | `#8844ff` | `#aa66ff` | Electric purple    |
| Magenta | `#ff44aa` | `#ff66cc` | Bright pink        |
| Cyan    | `#00aaff` | `#44ccff` | Electric blue      |
| White   | `#ffffff` | `#ffffff` | Pure white         |

## 📋 Prerequisites

### Required Dependencies

1. **Alacritty Terminal** (version 0.13+)

   ```bash
   # Ubuntu/Debian
   sudo apt install alacritty

   # Arch Linux
   sudo pacman -S alacritty

   # Fedora
   sudo dnf install alacritty
   ```
2. **JetBrains Mono Nerd Font**

   ```bash
   # Download and install from Nerd Fonts
   wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
   unzip JetBrainsMono.zip -d ~/.local/share/fonts/
   fc-cache -fv
   ```
3. **GNU Stow** (for dotfiles management)

   ```bash
   # Ubuntu/Debian
   sudo apt install stow

   # Arch Linux
   sudo pacman -S stow

   # Fedora
   sudo dnf install stow
   ```

### Optional Dependencies

- **Compositor** (for transparency effects):
  - Picom (X11)
  - Hyprland (Wayland)
  - Other compositors that support window transparency

## 🚀 Installation

### Method 1: Using GNU Stow (Recommended)

GNU Stow is the preferred method for managing dotfiles as it creates proper symlinks and makes updates seamless.

1. **Clone the dotfiles repository**:

   ```bash
   git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. **Backup existing configuration** (if any):

   ```bash
   mv ~/.config/alacritty ~/.config/alacritty.backup 2>/dev/null || true
   ```
3. **Install using GNU Stow**:

   ```bash
   # From the dotfiles directory
   stow alacritty
   ```
4. **Verify installation**:

   ```bash
   ls -la ~/.config/alacritty
   alacritty --version
   ```

### Method 2: Manual Symlink

If you prefer manual symlinks:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. **Create symbolic link**:

   ```bash
   # Backup existing config (if any)
   mv ~/.config/alacritty ~/.config/alacritty.backup 2>/dev/null || true

   # Create symbolic link
   ln -sf ~/dotfiles/alacritty/.config/alacritty ~/.config/alacritty
   ```

### Method 3: Manual Copy

For a one-time setup without symlinks:

1. **Copy configuration file**:
   ```bash
   mkdir -p ~/.config/alacritty
   cp ~/dotfiles/alacritty/.config/alacritty/alacritty.toml ~/.config/alacritty/
   ```

> **💡 Pro Tip**: Using GNU Stow is recommended because:
>
> - Easy to update: just `git pull && stow alacritty`
> - Clean uninstall: `stow -D alacritty`
> - Manages conflicts automatically
> - Maintains proper symlink structure

## ⌨️ Keyboard Shortcuts

| Shortcut         | Action        | Description                     |
| ---------------- | ------------- | ------------------------------- |
| `Ctrl+Shift+C` | Copy          | Copy selected text to clipboard |
| `Ctrl+Shift+V` | Paste         | Paste from clipboard            |
| `Ctrl+Shift+N` | New Window    | Open new Alacritty instance     |
| `Ctrl++`       | Increase Font | Make text larger                |
| `Ctrl+-`       | Decrease Font | Make text smaller               |
| `Ctrl+0`       | Reset Font    | Reset to default font size      |

## 🖱️ Mouse Controls

- **Right Click**: Paste selection (Unix-style)
- **Mouse Hidden**: Cursor automatically hides while typing
- **Scroll**: Navigate through terminal history

## 🎛️ Configuration Overview

### Window Settings

- **Opacity**: 50% transparency for aesthetic appeal
- **Decorations**: None (borderless window)
- **Padding**: 20px for visual breathing room
- **Dynamic Title**: Shows current directory/command

### Font Configuration

- **Family**: JetBrains Mono Nerd Font
- **Size**: 12pt (optimal for readability)
- **Styles**: Regular, Bold, Italic, Bold Italic

### Performance Settings

- **Scrollback**: 10,000 lines
- **Scroll Multiplier**: 3x speed
- **GPU Acceleration**: Enabled by default

## 🔧 Customization

### Changing Transparency

Edit the opacity value in `alacritty.toml`:

```toml
[window]
opacity = 0.7  # Change from 0.5 to 0.7 for less transparency
```

### Adjusting Font Size

Modify the font size:

```toml
[font]
size = 14.0  # Increase from 12.0 for larger text
```

### Color Scheme Modifications

All colors are defined in the `[colors]` section. You can modify any hex value to customize the theme.

## 🐛 Troubleshooting

### Font Not Found

If you see font warnings:

1. Ensure JetBrains Mono Nerd Font is installed
2. Run `fc-cache -fv` to refresh font cache
3. Restart Alacritty

### Transparency Not Working

1. Verify your compositor supports transparency
2. Check if transparency is enabled in your window manager
3. Try different opacity values (0.1 - 1.0)

### Performance Issues

1. Disable transparency temporarily: `opacity = 1.0`
2. Reduce scrollback history: `history = 5000`
3. Check GPU acceleration is working

## 📁 File Structure

```
alacritty/
├── README.md                           # This file
└── .config/
    └── alacritty/
        └── alacritty.toml              # Main configuration file
```

## 📚 Additional Resources

- [Alacritty Official Documentation](https://alacritty.org/)
- [Alacritty GitHub Repository](https://github.com/alacritty/alacritty)
- [JetBrains Mono Font](https://www.jetbrains.com/lp/mono/)
- [Nerd Fonts Project](https://www.nerdfonts.com/)
- [GNU Stow Documentation](https://www.gnu.org/software/stow/)
- [Managing Dotfiles with Stow](https://www.jakewiesler.com/blog/managing-dotfiles)

## 🛠️ Stow Management Commands

Once installed with GNU Stow, you can use these commands:

```bash
# Update configuration (pull latest changes)
cd ~/dotfiles
git pull
stow -R alacritty  # Restow to apply changes

# Uninstall/remove symlinks
stow -D alacritty

# Check what would be stowed (dry run)
stow -n -v alacritty
```

## 🤝 Contributing

Feel free to suggest improvements or report issues with this configuration!

## 📄 License

This configuration is part of the personal dotfiles collection. Feel free to use and modify as needed.

---

<div align="center">

**Happy Terminal Computing! 🚀**


</div>
