#!/bin/bash
# apply-theme.sh — Master theme application script
# Usage: apply-theme.sh <theme-name|wallpaper>

set -euo pipefail

THEME_DIR="$HOME/.config/theme"
COLORS_DIR="$THEME_DIR/colors"
TEMPLATES_DIR="$THEME_DIR/templates"
CURRENT="$COLORS_DIR/current.conf"

THEME_NAME="${1:-}"

if [[ -z "$THEME_NAME" ]]; then
    echo "Usage: apply-theme.sh <theme-name|wallpaper>"
    echo "Available themes:"
    ls "$COLORS_DIR/themes/" | sed 's/.conf//'
    exit 1
fi

# ── Resolve theme source ──────────────────────────────────
if [[ "$THEME_NAME" == "wallpaper" ]]; then
    WALLPAPER=$(readlink -f "$HOME/.config/hypr/current_wallpaper" 2>/dev/null || echo "")
    if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
        notify-send "Theme" "No current wallpaper found" -u warning
        exit 1
    fi

    # Try matugen first, fall back to wallust
    if command -v matugen &>/dev/null; then
        MATUGEN_OUT=$(matugen image "$WALLPAPER" --json 2>/dev/null || echo "")
        if [[ -n "$MATUGEN_OUT" ]]; then
            # Parse matugen JSON to our token format
            # matugen outputs Material You colors
            PRIMARY=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['primary'])" 2>/dev/null || echo "")
            if [[ -n "$PRIMARY" ]]; then
                SECONDARY=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['secondary'])" 2>/dev/null)
                TERTIARY=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['tertiary'])" 2>/dev/null)
                BG=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['background'])" 2>/dev/null)
                SURFACE=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['surface'])" 2>/dev/null)
                FG=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['on_background'])" 2>/dev/null)
                ERROR=$(echo "$MATUGEN_OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['colors']['dark']['error'])" 2>/dev/null)

                cat > "$CURRENT" <<EOF
# Wallpaper-generated (matugen) — $(basename "$WALLPAPER")
COLOR_BG="$BG"
COLOR_BG_ALT="$SURFACE"
COLOR_FG="$FG"
COLOR_FG_DIM="${FG}99"
COLOR_PRIMARY="$PRIMARY"
COLOR_SECONDARY="$SECONDARY"
COLOR_ACCENT="$TERTIARY"
COLOR_BORDER="$PRIMARY"
COLOR_WARN="#fabd2f"
COLOR_CRIT="$ERROR"
COLOR_SURFACE="$SURFACE"
COLOR_PINK="$SECONDARY"
COLOR_BG_ALPHA="0.95"
EOF
                THEME_NAME="wallpaper (matugen)"
            fi
        fi
    fi

    # Fallback to wallust
    if [[ ! -f "$CURRENT" ]] || ! grep -q "matugen" "$CURRENT" 2>/dev/null; then
        if command -v wallust &>/dev/null; then
            wallust run "$WALLPAPER" 2>/dev/null
            WALLUST_COLORS="$HOME/.cache/wallust/colors.sh"
            if [[ -f "$WALLUST_COLORS" ]]; then
                source "$WALLUST_COLORS"
                cat > "$CURRENT" <<EOF
# Wallpaper-generated (wallust) — $(basename "$WALLPAPER")
COLOR_BG="${background:-#1e1e2e}"
COLOR_BG_ALT="${color0:-#313244}"
COLOR_FG="${foreground:-#cdd6f4}"
COLOR_FG_DIM="${color8:-#a6adc8}"
COLOR_PRIMARY="${color5:-#cba6f7}"
COLOR_SECONDARY="${color4:-#89b4fa}"
COLOR_ACCENT="${color2:-#a6e3a1}"
COLOR_BORDER="${color5:-#cba6f7}"
COLOR_WARN="${color3:-#f9e2af}"
COLOR_CRIT="${color1:-#f38ba8}"
COLOR_SURFACE="${color0:-#45475a}"
COLOR_PINK="${color6:-#f5c2e7}"
COLOR_BG_ALPHA="0.95"
EOF
                THEME_NAME="wallpaper (wallust)"
            else
                notify-send "Theme" "wallust failed to generate colors" -u warning
                exit 1
            fi
        else
            notify-send "Theme" "Neither matugen nor wallust installed" -u warning
            exit 1
        fi
    fi
else
    # Named theme
    THEME_FILE="$COLORS_DIR/themes/${THEME_NAME}.conf"
    if [[ ! -f "$THEME_FILE" ]]; then
        notify-send "Theme" "Theme '$THEME_NAME' not found" -u warning
        exit 1
    fi
    cp "$THEME_FILE" "$CURRENT"
fi

# ── Load current colors ───────────────────────────────────
source "$CURRENT"

# User overrides (survives theme switches — e.g. opacity preference)
USER_OVERRIDES="$COLORS_DIR/user-overrides.conf"
if [[ -f "$USER_OVERRIDES" ]]; then
    source "$USER_OVERRIDES"
fi

# Strip # from hex for Hyprland rgba format
COLOR_BG_RAW="${COLOR_BG#\#}"
COLOR_BG_ALT_RAW="${COLOR_BG_ALT#\#}"
COLOR_FG_RAW="${COLOR_FG#\#}"
COLOR_FG_DIM_RAW="${COLOR_FG_DIM#\#}"
COLOR_PRIMARY_RAW="${COLOR_PRIMARY#\#}"
COLOR_SECONDARY_RAW="${COLOR_SECONDARY#\#}"
COLOR_ACCENT_RAW="${COLOR_ACCENT#\#}"
COLOR_BORDER_RAW="${COLOR_BORDER#\#}"
COLOR_WARN_RAW="${COLOR_WARN#\#}"
COLOR_CRIT_RAW="${COLOR_CRIT#\#}"
COLOR_SURFACE_RAW="${COLOR_SURFACE#\#}"
COLOR_PINK_RAW="${COLOR_PINK#\#}"

# Terminal-specific foreground (defaults to COLOR_FG if not set)
COLOR_TERM_FG="${COLOR_TERM_FG:-$COLOR_FG}"
COLOR_TERM_FG_RAW="${COLOR_TERM_FG#\#}"

# ── Apply templates ───────────────────────────────────────
apply_template() {
    local tpl="$1" output="$2"
    sed \
        -e "s|{{COLOR_BG}}|$COLOR_BG|g" \
        -e "s|{{COLOR_BG_ALT}}|$COLOR_BG_ALT|g" \
        -e "s|{{COLOR_FG}}|$COLOR_FG|g" \
        -e "s|{{COLOR_FG_DIM}}|$COLOR_FG_DIM|g" \
        -e "s|{{COLOR_PRIMARY}}|$COLOR_PRIMARY|g" \
        -e "s|{{COLOR_SECONDARY}}|$COLOR_SECONDARY|g" \
        -e "s|{{COLOR_ACCENT}}|$COLOR_ACCENT|g" \
        -e "s|{{COLOR_BORDER}}|$COLOR_BORDER|g" \
        -e "s|{{COLOR_WARN}}|$COLOR_WARN|g" \
        -e "s|{{COLOR_CRIT}}|$COLOR_CRIT|g" \
        -e "s|{{COLOR_SURFACE}}|$COLOR_SURFACE|g" \
        -e "s|{{COLOR_PINK}}|$COLOR_PINK|g" \
        -e "s|{{COLOR_BG_ALPHA}}|$COLOR_BG_ALPHA|g" \
        -e "s|{{COLOR_BG_RAW}}|$COLOR_BG_RAW|g" \
        -e "s|{{COLOR_BG_ALT_RAW}}|$COLOR_BG_ALT_RAW|g" \
        -e "s|{{COLOR_FG_RAW}}|$COLOR_FG_RAW|g" \
        -e "s|{{COLOR_FG_DIM_RAW}}|$COLOR_FG_DIM_RAW|g" \
        -e "s|{{COLOR_PRIMARY_RAW}}|$COLOR_PRIMARY_RAW|g" \
        -e "s|{{COLOR_SECONDARY_RAW}}|$COLOR_SECONDARY_RAW|g" \
        -e "s|{{COLOR_ACCENT_RAW}}|$COLOR_ACCENT_RAW|g" \
        -e "s|{{COLOR_BORDER_RAW}}|$COLOR_BORDER_RAW|g" \
        -e "s|{{COLOR_WARN_RAW}}|$COLOR_WARN_RAW|g" \
        -e "s|{{COLOR_CRIT_RAW}}|$COLOR_CRIT_RAW|g" \
        -e "s|{{COLOR_SURFACE_RAW}}|$COLOR_SURFACE_RAW|g" \
        -e "s|{{COLOR_PINK_RAW}}|$COLOR_PINK_RAW|g" \
        -e "s|{{COLOR_TERM_FG}}|$COLOR_TERM_FG|g" \
        -e "s|{{COLOR_TERM_FG_RAW}}|$COLOR_TERM_FG_RAW|g" \
        "$tpl" > "$output"
}

# Hyprland appearance
apply_template "$TEMPLATES_DIR/hyprland-appearance.conf.tpl" \
    "$HOME/.config/hypr/conf.d/appearance.conf"

# Waybar colors (injected into style.css as :root block)
apply_template "$TEMPLATES_DIR/waybar-colors.css.tpl" \
    "$HOME/.config/waybar/colors.css"

# Kitty colors
apply_template "$TEMPLATES_DIR/kitty-colors.conf.tpl" \
    "$HOME/.config/kitty/colors.conf"

# Rofi colors
apply_template "$TEMPLATES_DIR/rofi-colors.rasi.tpl" \
    "$HOME/.config/rofi/colors.rasi"

# swaync style (only if config dir exists)
if [[ -d "$HOME/.config/swaync" ]]; then
    apply_template "$TEMPLATES_DIR/swaync-style.css.tpl" \
        "$HOME/.config/swaync/style.css"
fi

# Hyprlock (full config from template)
apply_template "$TEMPLATES_DIR/hyprlock.conf.tpl" \
    "$HOME/.config/hypr/hyprlock.conf"

# wlogout style (only if config dir exists)
if [[ -d "$HOME/.config/wlogout" ]]; then
    apply_template "$TEMPLATES_DIR/wlogout-style.css.tpl" \
        "$HOME/.config/wlogout/style.css"
fi

# btop theme
if [[ -d "$HOME/.config/btop" ]]; then
    mkdir -p "$HOME/.config/btop/themes"
    apply_template "$TEMPLATES_DIR/btop-theme.theme.tpl" \
        "$HOME/.config/btop/themes/current-theme.theme"
    if [[ -f "$HOME/.config/btop/btop.conf" ]]; then
        sed -i 's|^color_theme = .*|color_theme = "current-theme"|' "$HOME/.config/btop/btop.conf"
    fi
fi

# starship palette
STARSHIP_CONF="$HOME/.config/starship.toml"
if [[ -f "$STARSHIP_CONF" ]]; then
    # Remove old generated palette block
    sed -i '/^# Starship color palette/,/^$/d' "$STARSHIP_CONF"
    sed -i '/^\[palettes\.theme\]/,/^$/d' "$STARSHIP_CONF"
    sed -i '/^palette = "theme"/d' "$STARSHIP_CONF"

    # Generate palette and append
    apply_template "$TEMPLATES_DIR/starship-palette.toml.tpl" /tmp/starship-palette-gen.toml

    # Add palette selector
    if ! grep -q '^palette' "$STARSHIP_CONF"; then
        sed -i '/^add_newline/a palette = "theme"' "$STARSHIP_CONF"
    fi

    # Append palette definition at end
    printf '\n' >> "$STARSHIP_CONF"
    cat /tmp/starship-palette-gen.toml >> "$STARSHIP_CONF"
    rm -f /tmp/starship-palette-gen.toml
fi

# lsd color theme
if [[ -d "$HOME/.config/lsd" ]]; then
    apply_template "$TEMPLATES_DIR/lsd-colors.yaml.tpl" \
        "$HOME/.config/lsd/colors.yaml"
fi

# bat syntax highlighting theme
if command -v bat &>/dev/null; then
    mkdir -p "$HOME/.config/bat/themes"
    apply_template "$TEMPLATES_DIR/bat-theme.tmTheme.tpl" \
        "$HOME/.config/bat/themes/space-station.tmTheme"
    bat cache --build &>/dev/null || true
fi

# Neovim colors (lua module for cyberdream)
mkdir -p "$HOME/.config/nvim/lua/theme"
apply_template "$TEMPLATES_DIR/nvim-colors.lua.tpl" \
    "$HOME/.config/nvim/lua/theme/colors.lua"

# tmux theme
mkdir -p "$HOME/.config/tmux"
apply_template "$TEMPLATES_DIR/tmux-colors.conf.tpl" \
    "$HOME/.config/tmux/theme.conf"

# GTK4/libadwaita (Nautilus, etc.)
apply_template "$TEMPLATES_DIR/gtk4-colors.css.tpl" \
    "$HOME/.config/gtk-4.0/style.css"

# swayimg colors
mkdir -p "$HOME/.config/swayimg"
apply_template "$TEMPLATES_DIR/swayimg-colors.lua.tpl" \
    "$HOME/.config/swayimg/colors.lua"

# sysdx TUI colors
mkdir -p "$HOME/.config/sysdx"
apply_template "$TEMPLATES_DIR/sysdx-config.toml.tpl" \
    "$HOME/.config/sysdx/config.toml"

# ── Live reload (parallelized — target <2s total) ────────

# Instant: terminal colors via OSC escape sequences (no restart needed)
# Build one big escape string and write once per pty
OSC_SEQ=""
OSC_SEQ+="\033]10;${COLOR_TERM_FG}\033\\"
OSC_SEQ+="\033]11;${COLOR_BG}\033\\"
OSC_SEQ+="\033]12;${COLOR_ACCENT}\033\\"
for i in "0;$COLOR_BG_ALT" "1;$COLOR_CRIT" "2;$COLOR_ACCENT" "3;$COLOR_WARN" \
         "4;$COLOR_PRIMARY" "5;$COLOR_PINK" "6;$COLOR_SECONDARY" "7;$COLOR_FG" \
         "8;$COLOR_SURFACE" "9;$COLOR_CRIT" "10;$COLOR_ACCENT" "11;$COLOR_WARN" \
         "12;$COLOR_PRIMARY" "13;$COLOR_PINK" "14;$COLOR_SECONDARY" "15;$COLOR_FG"; do
    OSC_SEQ+="\033]4;${i}\033\\"
done
for pty in /dev/pts/[0-9]*; do
    [[ -w "$pty" ]] && printf '%b' "$OSC_SEQ" > "$pty" 2>/dev/null &
done

# Instant: kitty remote control + config reload
if pgrep kitty &>/dev/null; then
    kitty @ --to unix:/tmp/kitty-sock set-colors --all --configured "$HOME/.config/kitty/colors.conf" 2>/dev/null || true
    pkill -USR1 kitty 2>/dev/null || true
fi

# Instant: tmux
tmux source-file "$HOME/.config/tmux/theme.conf" 2>/dev/null || true

# Instant: Hyprland
hyprctl reload 2>/dev/null || true

# Instant: swaync CSS reload (no restart needed)
swaync-client --reload-css 2>/dev/null || true

# Background: waybar restart (the only thing that truly needs a kill+restart)
{
    if pgrep waybar &>/dev/null; then
        pkill waybar 2>/dev/null
        sleep 0.3
        hyprctl dispatch exec waybar 2>/dev/null || waybar &
    fi
} &disown

# Background: bat cache rebuild
bat cache --build &>/dev/null &disown

# Background: neovim colorscheme reload
{
    for addr in $(find "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" /tmp -maxdepth 2 -name 'nvim.*.0' -type s 2>/dev/null); do
        nvim --server "$addr" --remote-send '<Esc>:lua package.loaded["theme.colors"]=nil; dofile(vim.fn.stdpath("config").."/lua/plugins/cyberdream.lua").config()<CR>' 2>/dev/null || true
    done
} &disown

# Wait for pty writes to finish
wait 2>/dev/null || true

# ── Notify ────────────────────────────────────────────────
notify-send -t 3000 "Theme Applied" "$THEME_NAME" -i preferences-desktop-theme
