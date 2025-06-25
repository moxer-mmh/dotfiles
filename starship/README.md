# 🚀 Starship Shell Prompt Configuration

<div align="center">

# 🚀 **STARSHIP** 🚀

## 🐲 Space Station Cosmic Dragon Prompt 🐲

[![Starship](https://img.shields.io/badge/Starship-1.16+-blue?style=for-the-badge&logo=starship&logoColor=white)](https://starship.rs/)
[![Shell Compatible](https://img.shields.io/badge/Shell-Zsh_Bash_Fish-green?style=for-the-badge)](https://starship.rs/guide/#🚀-installation)
[![Nerd Fonts](https://img.shields.io/badge/Nerd_Fonts-Required-orange?style=for-the-badge)](https://www.nerdfonts.com/)

</div>

## 📖 Overview

Professional shell prompt configuration featuring a **cosmic dragon theme** (龍) designed for the Space Station development environment. Provides intelligent context awareness, comprehensive language support, and stunning visual feedback across all major shells.

### 🌟 Key Features

| Feature                             | Description                          | Visual Indicator              |
| ----------------------------------- | ------------------------------------ | ----------------------------- |
| **🐲 Dragon Character**       | Dynamic status-based prompt symbol   | `龍` (Purple/Red/Green)     |
| **🖥️ OS Detection**         | Comprehensive operating system icons | `󰣇` `󰍉`  etc.           |
| **📂 Smart Directory**        | Intelligent path truncation          | `󰋜 ~ / project / src / …` |
| **🌿 Git Integration**        | Detailed repository status           | ` main (󰐗 2 󰛿 1)`         |
| **🔧 Language Detection**     | Multi-runtime version display        | ` 3.11.5 (venv)`            |
| **🐳 Container Awareness**    | Docker context integration           | ` production`               |
| **⏱️ Performance Tracking** | Command duration monitoring          | `took 2.5s`                 |
| **🌐 Network Context**        | SSH and hostname display             | `user on hostname`          |

---

## 🎨 Visual Preview

### Prompt Structure

```bash
[OS] username on hostname at directory via  main(status) via   3.11.5 via   18.16.0 took 1.2s
龍
```

### Example Output

```bash
󰣇 moxer_mmh on space-station at ~/dotfiles/starship via  main (󰐗 2 󰛿 1) via   3.11.5 (venv) took 1.2s
龍 starship config --default
```

### Status Colors

- **🟣 Purple Dragon**: Successful command execution
- **🔴 Red Dragon**: Failed command or error state
- **🟢 Green Dragon**: Vim command mode active

---

## ⚡ Quick Start

### 1. **Installation**

```bash
# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Or install via package manager
# Arch Linux
sudo pacman -S starship

# Install required Nerd Font
sudo pacman -S ttf-jetbrains-mono-nerd  # Arch Linux
# Or download from: https://github.com/ryanoasis/nerd-fonts

# Clone the dotfiles repository
git clone https://github.com/moxer-mmh/dotfiles.git ~/dotfiles

# Method 1: Using GNU Stow (recommended)
cd ~/dotfiles
stow starship

# Method 2: Manual symlink
ln -sf ~/dotfiles/starship/.config/starship.toml ~/.config/starship.toml
```

### 2. **Shell Integration**

Choose your shell and add the initialization command:

```bash
# Zsh (~/.zshrc)
eval "$(starship init zsh)"

# Bash (~/.bashrc)
eval "$(starship init bash)"

# Fish (~/.config/fish/config.fish)
starship init fish | source

# PowerShell (Microsoft.PowerShell_profile.ps1)
Invoke-Expression (&starship init powershell)
```

### 3. **Restart Shell**

```bash
# Start new shell session or reload configuration
exec $SHELL
```

---

## 🎯 Configuration Deep Dive

### Prompt Format Structure

The prompt format is carefully designed for optimal information density:

```toml
format = """
[](color_orange)\           # Orange separator
$os\                        # Operating system icon
$username\                  # Current user
$hostname\                  # Machine hostname
$kubernetes\                # K8s context (when applicable)
$directory\                 # Current working directory
$git_branch\                # Git branch name
$git_status\                # Detailed git status
$python\                    # Python version & venv
$nodejs\                    # Node.js version
$rust\                      # Rust version
$golang\                    # Go version
$java\                      # Java version
$docker_context\            # Docker context
$cmd_duration\              # Command execution time
$line_break\                # New line
[](bg:blue fg:white) $character """ # Dragon prompt
```

### Color Scheme Philosophy

| Color               | Usage                        | Psychological Effect           |
| ------------------- | ---------------------------- | ------------------------------ |
| **🟣 Purple** | Success, Git branches        | Creativity, wisdom, technology |
| **🔴 Red**    | Errors, warnings             | Urgency, attention, caution    |
| **🟢 Green**  | Success states, staged files | Growth, progress, safety       |
| **🟡 Yellow** | Warnings, durations          | Attention, energy, optimism    |
| **🔵 Cyan**   | Directories, Go lang         | Clarity, focus, reliability    |
| **🔵 Blue**   | Docker, backgrounds          | Trust, stability, depth        |
| **⚪ White**  | OS symbols, text             | Clarity, simplicity, contrast  |
| **🟠 Orange** | Separators, highlights       | Energy, enthusiasm, creativity |

---

## 🌐 Language & Tool Support

### Primary Languages

<details>
<summary><strong>  Python Development</strong></summary>

```toml
[python]
symbol = "  "                       # Python logo
format = 'via [${symbol}${version} (${virtualenv})]($style)'
style = "bold yellow"
detect_files = [
    "requirements.txt",              # pip requirements
    "pyproject.toml",                # Modern Python projects
    "setup.py",                      # Legacy setup files
    ".python-version",               # pyenv version file
    "Pipfile",                       # pipenv projects
    "__init__.py",                   # Python packages
]
detect_folders = ["venv", ".venv"]   # Virtual environments
```

**Features:**

- Virtual environment detection and display
- Multiple Python version managers (pyenv, conda, etc.)
- Project type auto-detection
- Color-coded version information

</details>

<details>
<summary><strong>🟢 Node.js Development</strong></summary>

```toml
[nodejs]
symbol = " "                      # Node.js logo icon
format = 'via [${symbol}${version} ]($style)' # Display Node version
style = "bold green"                 # Green color for Node.js
detect_files = [                     # Node.js project indicators
    "package.json",                  # npm/yarn projects
    ".node-version",                 # Node version file
    ".nvmrc"                         # nvm version file
]
```

**Features:**

- Package.json project detection
- Node version manager support (nvm, fnm)
- npm/yarn/pnpm compatibility
- Monorepo workspace awareness

</details>

<details>
<summary><strong>🦀 Rust Development</strong></summary>

```toml
[rust]
symbol = "󱘗 "                       # Rust logo
format = 'via [${symbol}${version} ]($style)'
style = "bold red"
detect_files = [
    "Cargo.toml",                    # Cargo project file
    "rust-project.json"              # Rust-analyzer project
]
```

**Features:**

- Cargo project detection
- Rust-analyzer integration
- Edition and toolchain awareness
- Workspace and crate detection

</details>

<details>
<summary><strong>🐹 Go Development</strong></summary>

```toml
[golang]
symbol = " "                      # Go gopher icon
format = 'via [${symbol}${version} ]($style)' # Display Go version
style = "bold cyan"                  # Cyan color for Go
detect_files = [                     # Go project indicators
    "go.mod",                        # Go modules file
    "go.sum",                        # Go dependencies checksum
    "go.work",                       # Go workspace file
    ".go-version",                   # Go version file
    "glide.yaml",                    # Legacy Glide dependency manager
    "Gopkg.yml",                     # Legacy Dep dependency manager
    "Gopkg.lock",                    # Legacy Dep lock file
]
```

**Features:**

- Go modules and workspace support
- Multiple Go version detection
- Legacy dependency manager support
- Build constraint awareness

</details>

### Additional Language Support

| Language          | Icon    | Detection Files                  | Style    |
| ----------------- | ------- | -------------------------------- | -------- |
| **Java**    | ` ` | `pom.xml`, `build.gradle`    | Bold Red |
| **C/C++**   | ` ` | `CMakeLists.txt`, `Makefile` | Default  |
| **Rust**    | `󱘗 ` | `Cargo.toml`                   | Bold Red |
| **Ruby**    | ` ` | `Gemfile`, `.ruby-version`   | Default  |
| **PHP**     | ` ` | `composer.json`                | Default  |
| **Swift**   | ` ` | `Package.swift`                | Default  |
| **Kotlin**  | ` ` | `*.kt`, `*.kts`              | Default  |
| **Scala**   | ` ` | `build.sbt`                    | Default  |
| **Haskell** | ` ` | `*.hs`, `stack.yaml`         | Default  |
| **Julia**   | ` ` | `Project.toml`                 | Default  |
| **Zig**     | ` ` | `build.zig`                    | Default  |

---

## 🔧 Git Integration

### Branch Display

```toml
[git_branch]
symbol = " "                       # Git branch icon
format = 'via [($symbol$branch)]($style)'
style = "bold purple"                # Purple for branches
```

### Comprehensive Status Indicators

| Status               | Icon   | Color  | Meaning                 |
| -------------------- | ------ | ------ | ----------------------- |
| **Up to date** | `󰘽` | Green  | Repository is clean     |
| **Modified**   | `󰛿` | Yellow | Files have changes      |
| **Staged**     | `󰐗` | Green  | Changes ready to commit |
| **Untracked**  | `󰋗` | Red    | New files not in Git    |
| **Deleted**    | `󰍶` | Red    | Files have been removed |
| **Renamed**    | `󱍸` | Yellow | Files have been moved   |
| **Conflicted** | ``     | Red    | Merge conflicts exist   |
| **Stashed**    | ``     | Green  | Changes saved in stash  |

### Remote Status

```bash
# Example outputs:
 main (󰘽 up-to-date)                # Clean repository
 feature (󰐗 2 󰛿 3  ahead=1)         # Staged, modified, ahead
 hotfix (󰋗 1  conflicted=2)         # Untracked files, conflicts
```

---

## 🐳 Container & Cloud Integration

### Docker Context

```toml
[docker_context]
symbol = " "                      # Docker whale
format = 'via [${symbol}${context} ]($style)'
style = "blue bold"
detect_files = [
    "docker-compose.yml",            # Docker Compose
    "docker-compose.yaml",           # Alternative format
    "Dockerfile"                     # Docker build file
]
```

### Kubernetes Integration

```toml
[kubernetes]
format = 'via [󱃾 $context\($namespace\)](bold purple)'
detect_files = ['k8s', 'kubernetes', 'Dockerfile', 'docker-compose.yml']
```

**Examples:**

```bash
via 󱃾 production(api)               # Production cluster, api namespace
via 󱃾 minikube(default)             # Local development cluster
via  production                     # Docker production context
```

---

## ⚙️ Advanced Customization

### Performance Tuning

```toml
# Global settings for optimal performance
command_timeout = 1000               # Prevent hanging on slow operations
add_newline = true                   # Improve prompt readability

# Disable unused modules for faster prompt
[memory_usage]
disabled = true                      # Disable if not needed

[time]
disabled = true                      # Disable if not using
```

### Custom Color Schemes

Create theme variants by modifying styles:

```toml
# Cyberpunk variant
[character]
success_symbol = "[龍](bright-purple)"
error_symbol = "[龍](bright-red)"

[git_branch]
style = "bright-cyan"

[directory]
style = "bright-blue"
```

### Module Ordering

Customize the prompt format to reorder elements:

```toml
# Minimal format
format = "$directory$git_branch$git_status$character"

# Development-focused format
format = """
$username$hostname\
$directory\
$git_branch$git_status\
$python$nodejs$rust$golang$java\
$docker_context$kubernetes\
$character"""
```

### Custom Modules

Add custom commands to the prompt:

```toml
[custom.k8s_context]
command = "kubectl config current-context"
when = "kubectl config current-context"
format = "via [⎈ $output]($style)"
style = "bold blue"
```

---

## 🚨 Troubleshooting

### Common Issues

<details>
<summary><strong>🔤 Icons Not Displaying</strong></summary>

**Problem**: Missing or broken icons in prompt

**Solutions**:

```bash
# Install Nerd Font
sudo pacman -S ttf-jetbrains-mono-nerd  # Arch Linux
brew install font-jetbrains-mono-nerd   # macOS
apt install fonts-jetbrains-mono         # Ubuntu/Debian

# Update font cache
fc-cache -fv

# Verify font installation
fc-list | grep -i jetbrains

# Configure terminal font
# Set terminal font to "JetBrains Mono Nerd Font"
```

</details>

<details>
<summary><strong>⚡ Slow Prompt Performance</strong></summary>

**Problem**: Prompt takes too long to appear

**Solutions**:

```toml
# Increase timeout
command_timeout = 2000

# Disable unused modules
[memory_usage]
disabled = true

[time]
disabled = true

# Optimize Git repositories
# Move large repos off network drives
# Use shallow clones for faster status checks
```

</details>

<details>
<summary><strong>🔴 Git Status Issues</strong></summary>

**Problem**: Git information not showing or incorrect

**Solutions**:

```bash
# Verify Git installation
git --version

# Check repository status manually
cd /path/to/repo && git status

# Ensure proper permissions
chmod -R 755 .git/

# Reset Git configuration if needed
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

</details>

<details>
<summary><strong>🐍 Language Detection Problems</strong></summary>

**Problem**: Language versions not detected

**Solutions**:

```bash
# Verify language installation
python --version
node --version
rustc --version

# Check PATH configuration
echo $PATH

# Ensure project files exist
ls -la  # Look for package.json, Cargo.toml, etc.

# Test detection manually
starship explain  # Debug prompt modules
```

</details>

### Debug Mode

Enable debugging for detailed troubleshooting:

```bash
# Export debug variables
export STARSHIP_LOG=debug
export RUST_LOG=debug

# Run starship with debug output
starship explain

# Check configuration syntax
starship config --default > /tmp/default.toml
diff ~/.config/starship.toml /tmp/default.toml
```

---

## 🔗 Integration Examples

### Terminal Integration

<details>
<summary><strong>🔹 Alacritty Integration</strong></summary>

Perfect integration with the Space Station Alacritty theme:

```toml
# ~/.config/alacritty/alacritty.toml
[font]
normal = { family = "JetBrains Mono Nerd Font", style = "Regular" }
size = 12.0

[colors.primary]
background = "#0a0a0f"
foreground = "#00ff88"

# Cosmic color scheme matches starship purple/cyan theme
```

</details>

<details>
<summary><strong>🔹 Tmux Integration</strong></summary>

Coordinate with tmux status bar:

```bash
# ~/.tmux.conf
set -g status-style "bg=#1e1e2e,fg=#00ff88"
set -g status-left "#[bg=#8844ff,fg=#0a0a0f] #S "
set -g status-right "#[bg=#00aaff,fg=#0a0a0f] %H:%M "

# Disable tmux status if using starship extensively
set -g status off
```

</details>

<details>
<summary><strong>🔹 VS Code Integration</strong></summary>

Terminal integration in VS Code:

```json
{
    "terminal.integrated.fontFamily": "JetBrains Mono Nerd Font",
    "terminal.integrated.fontSize": 12,
    "terminal.integrated.cursorStyle": "line",
    "terminal.integrated.cursorBlinking": true,
    "workbench.colorTheme": "Cosmic Theme"
}
```

</details>

### Shell-Specific Configuration

<details>
<summary><strong>🐚 Zsh Enhanced Setup</strong></summary>

```bash
# ~/.zshrc
# Starship initialization
eval "$(starship init zsh)"

# Enhanced completion
autoload -U compinit && compinit

# History configuration
HISTSIZE=50000
SAVEHIST=50000

# Aliases that work well with starship
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gst='git status'
alias gco='git checkout'
alias glog='git log --oneline --graph'
```

</details>

<details>
<summary><strong>🐠 Fish Enhanced Setup</strong></summary>

```fish
# ~/.config/fish/config.fish
# Starship initialization
starship init fish | source

# Fish-specific abbreviations
abbr -a gst git status
abbr -a gco git checkout
abbr -a glog 'git log --oneline --graph'
abbr -a ll 'ls -alF'

# Set variables
set -gx EDITOR nvim
set -gx STARSHIP_CONFIG ~/.config/starship.toml
```

</details>

---

## 📚 Additional Resources

### Official Documentation

- [Starship Official Website](https://starship.rs/)
- [Configuration Reference](https://starship.rs/config/)
- [Advanced Configuration](https://starship.rs/advanced-config/)

### Nerd Fonts Resources

- [Nerd Fonts Official Site](https://www.nerdfonts.com/)
- [Font Preview Gallery](https://www.nerdfonts.com/font-downloads)
- [JetBrains Mono Download](https://github.com/ryanoasis/nerd-fonts/releases)

### Shell Resources

- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- [Fish Shell Tutorial](https://fishshell.com/docs/current/tutorial.html)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)

### Development Tools

- [Git Documentation](https://git-scm.com/docs)
- [Docker Context Guide](https://docs.docker.com/engine/context/working-with-contexts/)
- [Kubernetes Context](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)

---

<div align="center">

## 🚀 Part of the Space Station Environment

| Component                         | Purpose              | Integration               |
| --------------------------------- | -------------------- | ------------------------- |
| **[Alacritty](../alacritty/)** | Terminal emulator    | Cosmic color scheme       |
| **[Hyprland](../hypr/)**       | Window manager       | Purple accent theme       |
| **[Rofi](../rofi/)**           | Application launcher | Dragon theme coordination |
| **[Starship](../starship/)**   | Shell prompt         | **This component**  |
| **[ZSH](../zsh/)**             | Shell configuration  | Starship integration      |

---

**🐲 Transform your terminal into a cosmic command center 🐲**

*Professional shell prompt for the modern space-age developer*

[![GitHub Stars](https://img.shields.io/github/stars/moxer-mmh/dotfiles?style=social)](https://github.com/moxer-mmh/dotfiles)
[![Last Commit](https://img.shields.io/github/last-commit/moxer-mmh/dotfiles?style=flat-square)](https://github.com/moxer-mmh/dotfiles/commits/main)

</div>
