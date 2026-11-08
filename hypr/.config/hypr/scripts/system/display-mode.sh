#!/usr/bin/env bash
# display-mode.sh : choisit comment l'écran externe (datashow) est utilisé.
#
#   mirror   duplique l'écran du portable sur l'écran externe
#   extend   utilise l'écran externe comme second moniteur
#   menu     affiche le choix dans rofi (Super+Shift+M)
#   status   affiche le mode mémorisé
#   restore  conservé pour compatibilité, ne fait plus rien
#
# Le choix est écrit dans un fichier d'état puis Hyprland est rechargé :
# modules/monitors.lua relit ce fichier à chaque chargement et pose la bonne
# règle. Le mode survit donc aux reloads (un changement de thème en déclenche
# un), et la résolution et la position restent définies à un seul endroit :
# modules/monitors.lua.

set -uo pipefail

EXTERNAL="HDMI-A-1"
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/display-mode"
ROFI_THEME="$HOME/.config/rofi/space-station.rasi"

LABEL_MIRROR="󰍺 Dupliquer l'écran"
LABEL_EXTEND="󰍹 Étendre (second écran)"

notify() {
    notify-send -a "Affichage" -i video-display "Affichage" "$1" -t 3000 || true
}

get_state() {
    local state
    state=$(cat "$STATE_FILE" 2>/dev/null) || state=""
    [[ "$state" == "mirror" ]] && echo "mirror" || echo "extend"
}

set_state() {
    mkdir -p "$(dirname "$STATE_FILE")" && printf '%s\n' "$1" > "$STATE_FILE"
}

external_connected() {
    local status_file
    for status_file in /sys/class/drm/card*-"$EXTERNAL"/status; do
        [[ -r "$status_file" && "$(<"$status_file")" == "connected" ]] && return 0
    done
    return 1
}

# Écrit le mode puis recharge : modules/monitors.lua applique la règle.
apply_mode() {
    set_state "$1" && hyprctl reload >/dev/null
}

cmd_mirror() {
    if ! external_connected; then
        notify "Aucun écran externe détecté sur $EXTERNAL."
        return 1
    fi
    apply_mode mirror || { notify "Échec de la duplication de l'écran."; return 1; }
    notify "Écran dupliqué sur $EXTERNAL."
}

cmd_extend() {
    apply_mode extend || { notify "Échec du passage en second écran."; return 1; }
    notify "$EXTERNAL utilisé comme second écran."
}

cmd_menu() {
    local choice marker_mirror="" marker_extend=""
    if [[ "$(get_state)" == "mirror" ]]; then
        marker_mirror=" (actuel)"
    else
        marker_extend=" (actuel)"
    fi
    choice=$(printf '%s\n%s\n' "$LABEL_MIRROR$marker_mirror" "$LABEL_EXTEND$marker_extend" |
        rofi -dmenu -i -theme "$ROFI_THEME" -p "󰍹 Affichage") || return 0
    case "$choice" in
        "$LABEL_MIRROR"*) cmd_mirror ;;
        "$LABEL_EXTEND"*) cmd_extend ;;
    esac
}

# Ancien point d'entrée appelé à chaque reload. modules/monitors.lua lit
# maintenant l'état lui-même, il n'y a donc plus rien à faire ici.
cmd_restore() {
    return 0
}

case "${1:-menu}" in
    mirror)  cmd_mirror ;;
    extend)  cmd_extend ;;
    menu)    cmd_menu ;;
    status)  get_state ;;
    restore) cmd_restore ;;
    *)
        echo "Usage: $(basename "$0") {mirror|extend|menu|status|restore}" >&2
        exit 2
        ;;
esac
