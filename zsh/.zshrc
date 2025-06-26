#!/usr/bin/env zsh

#═══════════════════════════════════════════════════════════════════════════════
# 🚀 SPACE STATION ZSH CONFIGURATION
#═══════════════════════════════════════════════════════════════════════════════
#
# A cosmic-themed Zsh configuration for the Space Station development environment.
# Features Oh My Zsh framework, Starship prompt, enhanced aliases, and developer
# tools integration for optimal terminal productivity and aesthetics.
#
# FEATURES:
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ • Oh My Zsh framework with Git plugin integration                          │
# │ • Starship prompt with cosmic theme and developer information              │
# │ • Enhanced command aliases with modern CLI tool replacements               │
# │ • Java JDK environment configuration for development                       │
# │ • Optimized for development workflow and system administration             │
# │ • Color-enhanced output with bat and lsd integrations                      │
# │ • Quick navigation and file manipulation shortcuts                         │
# └─────────────────────────────────────────────────────────────────────────────┘
#
# DEPENDENCIES:
# • oh-my-zsh: Zsh framework for configuration management
# • starship: Cross-shell prompt with cosmic configuration
# • lsd: Modern 'ls' replacement with icons and colors
# • bat: Syntax-highlighted 'cat' replacement
# • neovim: Modern text editor for development
# • git: Version control system integration
#
# INTEGRATION:
# • Coordinates with Starship cosmic prompt theme
# • Supports Alacritty terminal cosmic color scheme
# • Compatible with Hyprland compositor environment
# • Enhanced for development workflow productivity
#
# AUTHOR: Space Station Development Environment
# VERSION: 1.0.0
# LAST UPDATED: June 2025
#
#═══════════════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────────────
# OH MY ZSH FRAMEWORK CONFIGURATION
# Core Zsh enhancement framework with plugin management
#───────────────────────────────────────────────────────────────────────────────

# Oh My Zsh installation directory
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration (disabled in favor of Starship prompt)
ZSH_THEME=""                     # Empty to disable Oh My Zsh themes

# Plugin configuration for enhanced Zsh functionality
plugins=(git)                    # Git integration plugin for status and shortcuts

# Load Oh My Zsh framework
source $ZSH/oh-my-zsh.sh

#───────────────────────────────────────────────────────────────────────────────
# ENHANCED COMMAND ALIASES
# Modern CLI tool replacements and productivity shortcuts
#───────────────────────────────────────────────────────────────────────────────

# File and directory listing with modern tools
alias ls='lsd --color=auto --group-dirs=first'  # Modern 'ls' with icons and colors
alias ll='ls -lah --color=auto'                 # Long format with hidden files
alias la='ls -A'                                # List all files except . and ..

# Enhanced file viewing and manipulation
alias cat='bat --color=auto'                    # Syntax-highlighted file viewer
alias rmd='rm -rf'                              # Recursive directory removal

# System control shortcuts
alias poff='poweroff'                           # Quick system shutdown
alias rb='reboot'                               # Quick system restart
alias cls='clear'                               # Clear terminal screen

# Development tool shortcuts
alias n='nvim'                                  # Quick Neovim editor access
alias py='python3'                              # Python 3 interpreter shortcut

#───────────────────────────────────────────────────────────────────────────────
# STARSHIP PROMPT INITIALIZATION
# Cross-shell prompt with cosmic theme and developer information display
#───────────────────────────────────────────────────────────────────────────────

# Initialize Starship prompt (replaces default Zsh prompt)
eval "$(starship init zsh)"             # Load cosmic-themed prompt configuration

#───────────────────────────────────────────────────────────────────────────────
# DEVELOPMENT ENVIRONMENT CONFIGURATION
# Programming language and development tool environment setup
#───────────────────────────────────────────────────────────────────────────────

# Java Development Kit Configuration
export JAVA_HOME="/usr/lib/jvm/java-24-openjdk"    # Java 24 OpenJDK installation path
export PATH="$JAVA_HOME/bin:$PATH"                 # Add Java binaries to PATH

#═══════════════════════════════════════════════════════════════════════════════
# END OF ZSH CONFIGURATION
#
# This completes the Space Station Zsh configuration with enhanced productivity
# features, modern CLI tools, and development environment setup.
#
# CUSTOMIZATION NOTES:
# • Add new aliases in the "Enhanced Command Aliases" section
# • Modify plugin list in Oh My Zsh configuration for additional features
# • Environment variables can be added in the development section
# • Starship prompt customization is handled via ~/.config/starship.toml
#
# PERFORMANCE TIPS:
# • Keep plugin list minimal for faster shell startup
# • Use 'zsh -xvs' to debug slow startup times
# • Consider lazy-loading heavy plugins or tools
#
# USEFUL OH MY ZSH PLUGINS TO CONSIDER:
# • zsh-autosuggestions: Fish-like command suggestions
# • zsh-syntax-highlighting: Syntax highlighting for commands
# • docker: Docker command completions and aliases
# • kubectl: Kubernetes command completions
# • node: Node.js and npm completions
#
# Space Station Development Environment | Cosmic Zsh Configuration
# Version 1.0.0 | Last Updated: June 2025
#═══════════════════════════════════════════════════════════════════════════════

