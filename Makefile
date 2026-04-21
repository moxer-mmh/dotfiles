# 🌌 Cosmic Space Station Dotfiles - Automation Makefile
# =====================================================
# Professional dotfiles management with cosmic flair
# =====================================================

# Colors for cosmic output
CYAN := \033[36m
PURPLE := \033[35m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m
BOLD := \033[1m

# Cosmic configuration modules
MODULES := alacritty btop Code gh-dash gromit-mpx gtk hypr lazydocker lazygit nvim pavucontrol rofi starship swaync theme waybar wlogout zsh
OPTIONAL_MODULES := grub

# External tool sources
GROMIT_FORK := https://github.com/moxer-mmh/gromit-mpx.git
GROMIT_BRANCH := hyprland-patches
GROMIT_SRC := $(HOME)/code/gromit-mpx

# System info
HOSTNAME := $(shell hostname)
USER := $(shell whoami)
OS := $(shell uname -s)

.PHONY: help install install-manual backup check-deps clean status

# Default target - show cosmic help
help:
	@echo "$(BOLD)$(PURPLE)🌌 COSMIC SPACE STATION DOTFILES$(RESET)"
	@echo "$(CYAN)============================================$(RESET)"
	@echo ""
	@echo "$(BOLD)🚀 Main Commands:$(RESET)"
	@echo "  $(GREEN)install$(RESET)        - Full cosmic installation with dependency check"
	@echo "  $(GREEN)install-manual$(RESET) - Manual installation using stow"
	@echo "  $(GREEN)backup$(RESET)         - Backup existing configurations"
	@echo "  $(GREEN)check-deps$(RESET)     - Check system dependencies"
	@echo "  $(GREEN)clean$(RESET)          - Remove symlinks"
	@echo "  $(GREEN)status$(RESET)         - Show installation status"
	@echo ""
	@echo "$(BOLD)🎯 Module Commands:$(RESET)"
	@echo "  $(GREEN)install-<module>$(RESET) - Install specific module (e.g., make install-nvim)"
	@echo "  $(GREEN)remove-<module>$(RESET)  - Remove specific module"
	@echo ""
	@echo "$(BOLD)🛠️  Utility Commands:$(RESET)"
	@echo "  $(GREEN)waybar-restart$(RESET) - Restart waybar"
	@echo "  $(GREEN)hypr-reload$(RESET)    - Reload hyprland configuration"
	@echo "  $(GREEN)wallpaper-fix$(RESET)  - Fix wallpaper cycling"
	@echo "  $(GREEN)grub-theme$(RESET)     - Install GRUB cosmic themes"
	@echo "  $(GREEN)install-gromit$(RESET) - Build + install patched gromit-mpx from fork"
	@echo ""
	@echo "$(BOLD)📊 Available Modules:$(RESET)"
	@echo "  $(CYAN)$(MODULES)$(RESET)"
	@echo "  $(YELLOW)Optional: $(OPTIONAL_MODULES)$(RESET)"

# Full installation with cosmic ceremony
install: cosmic-banner check-deps backup install-modules post-install
	@echo "$(BOLD)$(GREEN)🎉 Cosmic Space Station Installation Complete!$(RESET)"
	@echo "$(PURPLE)⚡ Your development environment is ready for interstellar coding!$(RESET)"

# Manual installation using stow
install-manual: cosmic-banner
	@echo "$(CYAN)🔧 Installing dotfiles using GNU Stow...$(RESET)"
	@for module in $(MODULES); do \
		echo "$(YELLOW)📦 Installing $$module...$(RESET)"; \
		stow $$module 2>/dev/null || echo "$(RED)❌ Failed to install $$module$(RESET)"; \
	done
	@echo "$(GREEN)✅ Manual installation complete!$(RESET)"

# Backup existing configurations
backup:
	@echo "$(CYAN)💾 Creating backup of existing configurations...$(RESET)"
	@mkdir -p backup/$(shell date +%Y%m%d_%H%M%S)
	@for module in $(MODULES); do \
		if [ -d ~/.config/$$module ] && [ ! -L ~/.config/$$module ]; then \
			echo "$(YELLOW)📋 Backing up ~/.config/$$module$(RESET)"; \
			cp -r ~/.config/$$module backup/$(shell date +%Y%m%d_%H%M%S)/ 2>/dev/null || true; \
		fi; \
	done
	@echo "$(GREEN)✅ Backup complete!$(RESET)"

# Check system dependencies
check-deps:
	@echo "$(CYAN)🔍 Checking cosmic space station dependencies...$(RESET)"
	@deps="stow hyprland waybar alacritty neovim rofi dunst"; \
	missing=""; \
	for dep in $$deps; do \
		if ! command -v $$dep >/dev/null 2>&1; then \
			missing="$$missing $$dep"; \
		fi; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "$(RED)❌ Missing dependencies:$$missing$(RESET)"; \
		echo "$(YELLOW)📦 Install with: sudo pacman -S$$missing$(RESET)"; \
		exit 1; \
	else \
		echo "$(GREEN)✅ All dependencies found!$(RESET)"; \
	fi

# Install all core modules
install-modules:
	@echo "$(CYAN)🚀 Installing cosmic modules...$(RESET)"
	@for module in $(MODULES); do \
		echo "$(PURPLE)⚡ Installing $$module module...$(RESET)"; \
		$(MAKE) install-$$module; \
	done

# Post-installation tasks
post-install:
	@echo "$(CYAN)🌟 Running post-installation cosmic setup...$(RESET)"
	@echo "$(YELLOW)🔄 Reloading font cache...$(RESET)"
	@fc-cache -fv >/dev/null 2>&1 || true
	@echo "$(YELLOW)🎨 Setting up cosmic themes...$(RESET)"
	@$(MAKE) waybar-restart >/dev/null 2>&1 || true
	@echo "$(GREEN)✨ Post-installation complete!$(RESET)"

# Clean all symlinks
clean:
	@echo "$(CYAN)🧹 Removing cosmic dotfile symlinks...$(RESET)"
	@for module in $(MODULES); do \
		echo "$(YELLOW)🗑️  Removing $$module...$(RESET)"; \
		stow -D $$module 2>/dev/null || true; \
	done
	@echo "$(GREEN)✅ Cleanup complete!$(RESET)"

# Show installation status
status:
	@echo "$(BOLD)$(PURPLE)🌌 Cosmic Space Station Status$(RESET)"
	@echo "$(CYAN)================================$(RESET)"
	@echo "$(BOLD)System Info:$(RESET)"
	@echo "  Hostname: $(HOSTNAME)"
	@echo "  User: $(USER)"
	@echo "  OS: $(OS)"
	@echo ""
	@echo "$(BOLD)Module Status:$(RESET)"
	@for module in $(MODULES); do \
		if [ -L ~/.config/$$module ]; then \
			echo "  $(GREEN)✅ $$module$(RESET) - $(shell readlink ~/.config/$$module)"; \
		elif [ -d ~/.config/$$module ]; then \
			echo "  $(YELLOW)📂 $$module$(RESET) - directory exists (not symlinked)"; \
		else \
			echo "  $(RED)❌ $$module$(RESET) - not found"; \
		fi; \
	done

# Individual module installation targets
define INSTALL_MODULE_TEMPLATE
install-$(1):
	@echo "$(PURPLE)⚡ Installing $(1) module...$(RESET)"
	@if [ -d "$(1)" ]; then \
		stow $(1) && echo "$(GREEN)✅ $(1) installed successfully!$(RESET)" || echo "$(RED)❌ Failed to install $(1)$(RESET)"; \
	else \
		echo "$(RED)❌ Module $(1) not found!$(RESET)"; \
	fi

remove-$(1):
	@echo "$(YELLOW)🗑️  Removing $(1) module...$(RESET)"
	@stow -D $(1) 2>/dev/null && echo "$(GREEN)✅ $(1) removed!$(RESET)" || echo "$(RED)❌ Failed to remove $(1)$(RESET)"
endef

# Generate install/remove targets for each module
$(foreach module,$(MODULES),$(eval $(call INSTALL_MODULE_TEMPLATE,$(module))))

# Utility commands for cosmic space station management
waybar-restart:
	@echo "$(CYAN)🎮 Restarting Space Station Control Panel (Waybar)...$(RESET)"
	@pkill waybar 2>/dev/null || true
	@sleep 1
	@waybar &
	@echo "$(GREEN)✅ Waybar restarted!$(RESET)"

hypr-reload:
	@echo "$(CYAN)🔄 Reloading Hyprland configuration...$(RESET)"
	@hyprctl reload
	@echo "$(GREEN)✅ Hyprland reloaded!$(RESET)"

wallpaper-fix:
	@echo "$(CYAN)🖼️  Fixing cosmic wallpaper cycling...$(RESET)"
	@pkill -f wallpaper-daemon || true
	@pkill -f wallpaper-cycle || true
	@pkill awww-daemon || true
	@sleep 2
	@awww-daemon &
	@sleep 1
	@~/.config/hypr/scripts/wallpaper/wallpaper-daemon.sh &
	@echo "$(GREEN)✅ Wallpaper cycling restored!$(RESET)"

theme-apply:
	@echo "$(CYAN)🎨 Applying theme...$(RESET)"
	@if [ -n "$(THEME)" ]; then \
		~/.config/theme/scripts/apply-theme.sh $(THEME); \
	else \
		echo "$(YELLOW)Usage: make theme-apply THEME=<name>$(RESET)"; \
		echo "$(CYAN)Available themes:$(RESET)"; \
		ls ~/.config/theme/colors/themes/ 2>/dev/null | sed 's/.conf//'; \
	fi

theme-picker:
	@echo "$(CYAN)🎨 Opening theme picker...$(RESET)"
	@~/.config/theme/scripts/theme-picker.sh

swaync-restart:
	@echo "$(CYAN)🔔 Restarting notification daemon...$(RESET)"
	@pkill swaync 2>/dev/null || true
	@sleep 1
	@swaync &
	@echo "$(GREEN)✅ SwayNC restarted!$(RESET)"

# gromit-mpx — build the patched binary from the moxer-mmh fork and stow the cfg.
# Needed on fresh installs because upstream gromit-mpx misbehaves under
# Hyprland/Xwayland (blurry strokes, --reload is a no-op, double-free on COPY
# cfg entries). Patches live on the hyprland-patches branch of the fork.
# Dependencies (Arch): base-devel cmake gtk3 libxi libappindicator-gtk3
install-gromit:
	@echo "$(CYAN)🖊️  Building gromit-mpx (patched for Hyprland)...$(RESET)"
	@if [ ! -d "$(GROMIT_SRC)/.git" ]; then \
		echo "$(YELLOW)📥 Cloning $(GROMIT_FORK) -> $(GROMIT_SRC)$(RESET)"; \
		mkdir -p $(HOME)/code; \
		git clone -b $(GROMIT_BRANCH) $(GROMIT_FORK) $(GROMIT_SRC) || exit 1; \
	else \
		echo "$(YELLOW)🔄 Fork already present, syncing $(GROMIT_BRANCH)...$(RESET)"; \
		git -C $(GROMIT_SRC) fetch origin $(GROMIT_BRANCH) >/dev/null 2>&1 || true; \
		git -C $(GROMIT_SRC) checkout $(GROMIT_BRANCH) >/dev/null 2>&1 || exit 1; \
		git -C $(GROMIT_SRC) pull --ff-only origin $(GROMIT_BRANCH) >/dev/null 2>&1 || true; \
	fi
	@echo "$(YELLOW)⚙️  Configuring cmake (clean build)...$(RESET)"
	@rm -rf $(GROMIT_SRC)/build
	@mkdir -p $(GROMIT_SRC)/build
	@cd $(GROMIT_SRC)/build && cmake .. >/dev/null
	@echo "$(YELLOW)🔨 Building (nproc=$(shell nproc))...$(RESET)"
	@cd $(GROMIT_SRC)/build && make -j$(shell nproc) >/dev/null
	@echo "$(YELLOW)📦 Installing binary to /usr/local/bin (requires sudo)...$(RESET)"
	@cd $(GROMIT_SRC)/build && sudo make install >/dev/null
	@echo "$(YELLOW)🔗 Linking gromit-mpx.cfg + .ini via stow...$(RESET)"
	@$(MAKE) install-gromit-mpx
	@# gromit-mpx rewrites its .ini on exit (would reset Opacity=1.0 back to
	@# 0.75). chattr +i on the dotfiles inode is shared across the stow link
	@# and blocks that rewrite. Idempotent — safe to re-run.
	@echo "$(YELLOW)🔒 Setting chattr +i on gromit-mpx.ini (prevents opacity reset)...$(RESET)"
	@sudo chattr +i $(PWD)/gromit-mpx/.config/gromit-mpx.ini 2>/dev/null || true
	@echo "$(GREEN)✅ gromit-mpx ready: $$(command -v gromit-mpx)$(RESET)"

# GRUB theme installation
grub-theme:
	@echo "$(CYAN)🚀 Installing cosmic GRUB themes...$(RESET)"
	@if [ -d "grub" ]; then \
		echo "$(YELLOW)⚠️  GRUB theme installation requires sudo access$(RESET)"; \
		echo "$(PURPLE)Available themes: Cyberpunk, CyberRe, starfield$(RESET)"; \
		echo "$(CYAN)Usage: sudo make grub-install THEME=Cyberpunk$(RESET)"; \
	else \
		echo "$(RED)❌ GRUB themes not found!$(RESET)"; \
	fi

grub-install:
ifndef THEME
	@echo "$(RED)❌ Please specify THEME (e.g., make grub-install THEME=Cyberpunk)$(RESET)"
	@exit 1
endif
	@echo "$(CYAN)🎨 Installing $(THEME) GRUB theme...$(RESET)"
	@if [ -d "grub/themes/$(THEME)" ]; then \
		sudo cp -r grub/themes/$(THEME) /boot/grub/themes/; \
		echo "$(GREEN)✅ $(THEME) theme installed!$(RESET)"; \
		echo "$(YELLOW)📝 Update /etc/default/grub with: GRUB_THEME=/boot/grub/themes/$(THEME)/theme.txt$(RESET)"; \
		echo "$(YELLOW)🔄 Then run: sudo grub-mkconfig -o /boot/grub/grub.cfg$(RESET)"; \
	else \
		echo "$(RED)❌ Theme $(THEME) not found!$(RESET)"; \
	fi

# Cosmic banner
cosmic-banner:
	@echo "$(BOLD)$(PURPLE)"
	@echo "╔══════════════════════════════════════════════════╗"
	@echo "║               🌌 COSMIC DOTFILES 🌌               ║"
	@echo "║          Space Station Setup Protocol           ║"
	@echo "╚══════════════════════════════════════════════════╝"
	@echo "$(RESET)"

# Development helpers
dev-setup: install
	@echo "$(CYAN)🛠️  Setting up development environment...$(RESET)"
	@echo "$(YELLOW)📦 Installing additional development tools...$(RESET)"
	@# Add any additional development setup here

# Update all git submodules (if any)
update:
	@echo "$(CYAN)🔄 Updating cosmic configurations...$(RESET)"
	@git pull origin main
	@echo "$(GREEN)✅ Configurations updated!$(RESET)"

# Emergency restore
emergency-restore:
	@echo "$(RED)🚨 EMERGENCY RESTORE PROTOCOL$(RESET)"
	@echo "$(YELLOW)⚠️  This will remove all dotfile symlinks$(RESET)"
	@read -p "Continue? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	@$(MAKE) clean
	@echo "$(GREEN)✅ Emergency restore complete!$(RESET)"
