# 🚀 Space Station Zsh Configuration

<div align="center">

![Zsh](https://img.shields.io/badge/Shell-Zsh-green?style=for-the-badge&logo=gnu-bash)
![Framework](https://img.shields.io/badge/Framework-Oh%20My%20Zsh-blue?style=for-the-badge)
![Prompt](https://img.shields.io/badge/Prompt-Starship-purple?style=for-the-badge&logo=starship)

*A cosmic-themed shell configuration with enhanced productivity and modern CLI tools*

</div>

## ✨ Features

### 🌌 **Cosmic Shell Experience**
- **Starship Prompt**: Cross-shell prompt with cosmic dragon theme (龍)
- **Oh My Zsh Integration**: Robust framework with Git plugin support
- **Modern CLI Tools**: Enhanced replacements for traditional Unix commands
- **Developer Focus**: Optimized for programming and system administration

### 📊 **Enhanced Productivity**
- **Smart Aliases**: Intuitive shortcuts for common operations
- **Syntax Highlighting**: Color-coded command output with bat and lsd
- **Git Integration**: Comprehensive version control workflow support
- **Development Tools**: Quick access to editors, interpreters, and build tools

### 🔧 **Professional Features**
- **JetBrains Mono Font**: Consistent typography with Nerd Font icons
- **Java Environment**: Pre-configured JDK setup for development
- **Performance Optimized**: Minimal plugin load for fast shell startup
- **Cross-Platform**: Compatible with various Unix-like systems

## 🎨 Integration Overview

### Shell Ecosystem
```bash
┌─────────────────────────────────────────────────────────────────┐
│                    Space Station Shell Stack                   │
├─────────────────────────────────────────────────────────────────┤
│ Terminal: Alacritty (Cosmic Nebula Theme)                      │
│ Shell:    Zsh + Oh My Zsh Framework                           │
│ Prompt:   Starship (Cosmic Dragon Theme)                      │
│ Tools:    lsd, bat, neovim, git                              │
│ Font:     JetBrains Mono Nerd Font                           │
└─────────────────────────────────────────────────────────────────┘
```

### Command Enhancement
| Traditional | Enhanced | Description |
|-------------|----------|-------------|
| `ls` | `lsd --color=auto --group-dirs=first` | Icons, colors, directory grouping |
| `cat` | `bat --color=auto` | Syntax highlighting, line numbers |
| `vim` | `nvim` (aliased as `n`) | Modern Neovim editor |
| `poweroff` | `poff` | Quick system shutdown |
| `python` | `py` | Python 3 interpreter shortcut |

## 📋 Prerequisites

### Required Dependencies

1. **Zsh Shell** (version 5.8+)
   ```bash
   # Ubuntu/Debian
   sudo apt install zsh

   # Arch Linux
   sudo pacman -S zsh

   # Fedora
   sudo dnf install zsh
   ```

2. **Oh My Zsh Framework**
   ```bash
   # Install Oh My Zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Starship Prompt**
   ```bash
   # Install Starship
   curl -sS https://starship.rs/install.sh | sh

   # Or via package manager
   # Arch Linux
   sudo pacman -S starship

   # Homebrew
   brew install starship
   ```

4. **JetBrains Mono Nerd Font**
   ```bash
   # Download and install from Nerd Fonts
   wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
   unzip JetBrainsMono.zip -d ~/.local/share/fonts/
   fc-cache -fv
   ```

### Enhanced CLI Tools

1. **lsd** (Modern ls replacement)
   ```bash
   # Arch Linux
   sudo pacman -S lsd

   # Ubuntu/Debian
   sudo apt install lsd

   # Cargo
   cargo install lsd
   ```

2. **bat** (Syntax-highlighted cat)
   ```bash
   # Arch Linux
   sudo pacman -S bat

   # Ubuntu/Debian
   sudo apt install bat

   # Cargo
   cargo install bat
   ```

3. **Neovim** (Modern text editor)
   ```bash
   # Arch Linux
   sudo pacman -S neovim

   # Ubuntu/Debian
   sudo apt install neovim

   # Homebrew
   brew install neovim
   ```

### Optional Dependencies

- **GNU Stow**: For dotfiles management
- **Git**: Version control integration
- **Java JDK**: For Java development (pre-configured for OpenJDK 24)

## 🚀 Installation

### Method 1: Using GNU Stow (Recommended)

1. **Clone the dotfiles repository**:
   ```bash
   git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Backup existing Zsh configuration** (if any):
   ```bash
   mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true
   ```

3. **Install using GNU Stow**:
   ```bash
   # From the dotfiles directory
   stow zsh
   ```

4. **Change default shell to Zsh** (if not already):
   ```bash
   # Check current shell
   echo $SHELL

   # Change to Zsh
   chsh -s $(which zsh)
   ```

5. **Start new Zsh session**:
   ```bash
   exec zsh
   ```

### Method 2: Manual Installation

1. **Clone and copy configuration**:
   ```bash
   git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles
   
   # Backup existing config
   mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true
   
   # Copy configuration
   cp ~/dotfiles/zsh/.zshrc ~/.zshrc
   ```

2. **Change default shell**:
   ```bash
   chsh -s $(which zsh)
   exec zsh
   ```

### Method 3: Direct Symlink

1. **Create symbolic link**:
   ```bash
   # Backup existing config
   mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true
   
   # Create symbolic link
   ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
   
   # Change shell and restart
   chsh -s $(which zsh)
   exec zsh
   ```

## 📁 File Structure

```
zsh/
├── README.md                           # This documentation
└── .zshrc                              # Main Zsh configuration file
```

## ⚙️ Configuration Overview

### Oh My Zsh Framework Setup

```bash
# Framework configuration
export ZSH="$HOME/.oh-my-zsh"           # Oh My Zsh directory
ZSH_THEME=""                            # Disabled (using Starship)
plugins=(git)                           # Git integration plugin
source $ZSH/oh-my-zsh.sh               # Load framework
```

### Enhanced Command Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `ls` | `lsd --color=auto --group-dirs=first` | Modern file listing with icons |
| `ll` | `ls -lah --color=auto` | Long format with all files |
| `la` | `ls -A` | All files except . and .. |
| `cat` | `bat --color=auto` | Syntax-highlighted file viewer |
| `n` | `nvim` | Quick Neovim access |
| `py` | `python3` | Python 3 interpreter |
| `cls` | `clear` | Clear terminal screen |
| `poff` | `poweroff` | System shutdown |
| `rb` | `reboot` | System restart |
| `rmd` | `rm -rf` | Recursive directory removal |

### Development Environment

```bash
# Java JDK Configuration
export JAVA_HOME="/usr/lib/jvm/java-24-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
```

### Starship Prompt Integration

```bash
# Cosmic dragon prompt initialization
eval "$(starship init zsh)"
```

## 🎮 Usage

### Basic Navigation

```bash
# Enhanced file listing
ls                    # Modern ls with icons and colors
ll                    # Long format with all details
la                    # Show all files including hidden

# File viewing
cat script.py         # Syntax-highlighted Python code
bat README.md         # View with line numbers and syntax

# Quick editing
n config.toml         # Open in Neovim
```

### Development Workflow

```bash
# Git operations (with Oh My Zsh git plugin)
gst                   # git status
gco main              # git checkout main
glog                  # git log --oneline --graph
ga .                  # git add .
gcmsg "commit"        # git commit -m "commit"

# Python development
py script.py          # Run Python script
py -m pip install package  # Install Python package

# Java development (with pre-configured JAVA_HOME)
javac HelloWorld.java # Compile Java source
java HelloWorld       # Run Java program
```

### System Administration

```bash
# System control
cls                   # Clear terminal
poff                  # Shutdown system
rb                    # Restart system

# File operations
rmd old_directory     # Remove directory recursively
```

## 🔧 Customization

### Adding New Aliases

Edit the aliases section in `.zshrc`:

```bash
# Add custom aliases
alias gpu='nvidia-smi'                    # GPU status
alias df='df -h'                          # Human-readable disk usage
alias free='free -h'                      # Human-readable memory usage
alias grep='grep --color=auto'            # Colored grep output
```

### Installing Additional Oh My Zsh Plugins

```bash
# Clone plugins to Oh My Zsh directory
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Add to plugins array in .zshrc
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    kubectl
)
```

### Environment Variables

Add development tool configurations:

```bash
# Node.js configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Rust configuration
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

# Go configuration
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
```

### Starship Prompt Customization

The Starship prompt is configured via `~/.config/starship.toml`. See the [Starship README](../starship/README.md) for detailed customization options.

## 🔗 Integration

### Terminal Integration

Perfect integration with Space Station terminal setup:

```bash
# Alacritty terminal configuration
# ~/.config/alacritty/alacritty.toml
[font]
normal = { family = "JetBrains Mono Nerd Font" }

[colors.primary]
background = "#0a0a0f"      # Deep space black
foreground = "#00ff88"      # Neon green text
```

### Hyprland Integration

Window manager keybindings for terminal:

```bash
# ~/.config/hypr/hyprland.conf
bind = $mainMod, Return, exec, alacritty
bind = $mainMod SHIFT, Return, exec, alacritty --working-directory $(pwd)
```

### Tmux Integration

Session management with Zsh:

```bash
# Create development session
tmux new-session -d -s dev
tmux send-keys -t dev 'cd ~/projects && ls' Enter

# Attach to session
tmux attach-session -t dev
```

## 🐛 Troubleshooting

### Common Issues

**Zsh not starting or errors on startup**:
```bash
# Check Zsh installation
which zsh
zsh --version

# Test configuration
zsh -n ~/.zshrc

# Debug startup
zsh -xvs
```

**Oh My Zsh not found**:
```bash
# Reinstall Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Check installation
ls -la ~/.oh-my-zsh
```

**Starship prompt not showing**:
```bash
# Check Starship installation
starship --version

# Test initialization
starship init zsh

# Debug prompt
starship explain
```

**Command aliases not working**:
```bash
# Reload configuration
source ~/.zshrc

# Check if tools are installed
which lsd bat nvim

# Install missing tools
sudo pacman -S lsd bat neovim  # Arch Linux
```

**Font icons not displaying**:
```bash
# Install Nerd Font
sudo pacman -S ttf-jetbrains-mono-nerd

# Update font cache
fc-cache -fv

# Verify installation
fc-list | grep -i jetbrains
```

### Performance Issues

**Slow shell startup**:
```bash
# Time shell startup
time zsh -i -c exit

# Disable plugins temporarily
# Comment out plugins in .zshrc
plugins=()

# Use minimal configuration for debugging
cp ~/.zshrc ~/.zshrc.backup
echo 'eval "$(starship init zsh)"' > ~/.zshrc
```

**Plugin conflicts**:
```bash
# Test with minimal plugins
plugins=(git)

# Add plugins one by one to identify conflicts
plugins=(git zsh-autosuggestions)
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

## 📚 Advanced Configuration

### Custom Functions

Add useful functions to `.zshrc`:

```bash
# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
killp() {
    ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}
```

### History Configuration

Enhanced history management:

```bash
# History settings
HISTSIZE=50000                   # Lines in memory
SAVEHIST=50000                   # Lines in history file
HISTFILE=~/.zsh_history         # History file location

# History options
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_VERIFY              # Show command before executing from history
setopt SHARE_HISTORY            # Share history between sessions
setopt APPEND_HISTORY           # Append to history file
setopt INC_APPEND_HISTORY       # Add commands immediately
```

### Completion System

Enhanced autocompletion:

```bash
# Enable completion system
autoload -U compinit && compinit

# Completion options
setopt COMPLETE_ALIASES         # Complete aliases
setopt AUTO_LIST                # List choices on ambiguous completion
setopt AUTO_MENU                # Show menu on successive tab press
setopt AUTO_PARAM_SLASH         # Add slash after directory completion

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
```

## 🛠️ Stow Management Commands

```bash
# Update configuration
cd ~/dotfiles
git pull
stow -R zsh  # Restow to apply changes

# Uninstall
stow -D zsh

# Check what would be stowed
stow -n -v zsh
```

## 📚 Additional Resources

### Documentation
- [Zsh Documentation](https://zsh.sourceforge.io/Doc/) - Official Zsh manual
- [Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki) - Framework documentation
- [Starship Configuration](https://starship.rs/config/) - Prompt customization

### Plugins and Themes
- [Oh My Zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) - Official plugin list
- [Awesome Zsh Plugins](https://github.com/unixorn/awesome-zsh-plugins) - Community plugins
- [Zsh Users](https://github.com/zsh-users) - Popular plugin organization

### Modern CLI Tools
- [lsd](https://github.com/Peltoche/lsd) - Modern ls replacement
- [bat](https://github.com/sharkdp/bat) - Enhanced cat with syntax highlighting
- [exa](https://github.com/ogham/exa) - Alternative ls replacement
- [fd](https://github.com/sharkdp/fd) - Modern find replacement

## 🤝 Contributing

### Reporting Issues
- Check existing issues in the dotfiles repository
- Provide Zsh version and error output
- Include relevant system information

### Submitting Improvements
- Fork the repository
- Test changes with multiple shells and systems
- Follow existing configuration style
- Document new features and aliases

## 📄 License

This configuration is part of the Space Station development environment dotfiles collection. Feel free to use, modify, and share.

---

<div align="center">

**Space Station Development Environment** | Cosmic shell productivity suite  
*Transform your terminal into a powerful development command center* 🚀

**🐲 Powered by Starship • Enhanced by Oh My Zsh • Optimized for Developers 🐲**

</div>
