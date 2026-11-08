-- Autostart
-- "hyprland.start" fires once per session, never on reload (the old exec-once).

local startup = {
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    -- Activate the systemd graphical session so xdg-desktop-portal can start.
    -- The portal has Requisite=graphical-session.target; without this, screen
    -- sharing (Discord, Brave, OBS, etc.) silently fails. hyprland-session.target
    -- BindsTo graphical-session.target, pulling it active.
    "systemctl --user start hyprland-session.target",
    "gnome-keyring-daemon --start --components=secrets",

    -- Clipboard
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",

    -- Authentication agent
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",

    -- Network tray
    "nm-applet --indicator",

    -- Idle management: disabled by default (use the caffeine toggle to enable)
    -- "hypridle",

    -- Night light (warm 3000K default)
    "wlsunset -t 3000 -T 3001",

    -- Master startup (waybar, wallpaper, swaync, battery, udiskie)
    "~/.config/hypr/scripts/space-station-startup.sh",
}

-- Screen annotation overlay, kept disabled (it is started on demand by Super+I).
-- Uses the patched binary at /usr/local/bin/gromit-mpx: stock /usr/bin/gromit-mpx
-- hardcodes canvas opacity to 0.75 in on_composited_changed(), so strokes render
-- faded under any compositor. GDK_BACKEND=x11 because gromit-mpx is X11-only.
-- "sh -c 'sleep 4 && env GDK_BACKEND=x11 /usr/local/bin/gromit-mpx'",

-- The old `exec = display-mode.sh restore` line is gone: modules/monitors.lua
-- now reads the display-mode state file itself on every (re)load.

hl.on("hyprland.start", function()
    for _, cmd in ipairs(startup) do
        hl.exec_cmd(cmd)
    end
end)
