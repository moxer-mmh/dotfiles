-- Environment variables

local env = {
    -- Cursor
    XCURSOR_THEME = "Bibata-Modern-Amber",
    XCURSOR_SIZE  = "24",

    -- Qt
    QT_QPA_PLATFORMTHEME = "qt6ct",
    QT_QPA_PLATFORM      = "wayland",

    -- Wayland backends
    GDK_BACKEND     = "wayland",
    SDL_VIDEODRIVER = "wayland",
    CLUTTER_BACKEND = "wayland",

    -- XDG
    XDG_CURRENT_DESKTOP = "Hyprland",
    XDG_SESSION_TYPE    = "wayland",
    XDG_SESSION_DESKTOP = "Hyprland",

    -- Route GTK file dialogs through xdg-desktop-portal so native (non-Flatpak)
    -- Chromium/Electron apps (Brave, Discord, VS Code) get the GTK portal picker
    -- with our bookmarks and theme instead of Chromium's built-in one.
    GTK_USE_PORTAL = "1",
}

for name, value in pairs(env) do
    hl.env(name, value)
end
