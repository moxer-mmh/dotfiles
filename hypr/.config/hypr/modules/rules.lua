-- Window rules
-- `class` and `title` in `match` are RE2 regexes, matched on the initial value.

-- Workspace assignments
local workspace_by_class = {
    { class = "kitty",         workspace = "1" },
    { class = "brave-browser", workspace = "2" },
    { class = "Code",          workspace = "3" },
    { class = "obsidian",      workspace = "5" },
    { class = "Spotify",       workspace = "7 silent" },
}

for _, entry in ipairs(workspace_by_class) do
    hl.window_rule({
        name      = "workspace-" .. entry.class,
        match     = { class = entry.class },
        workspace = entry.workspace,
    })
end

-- Float utility windows, some with a fixed size
local floating = {
    { match = { class = "pavucontrol" },           size = { 800, 500 } },
    { match = { class = "nm-connection-editor" } },
    { match = { class = "blueman-manager" },       size = { 800, 500 } },
    { match = { class = "org.gnome.Calculator" } },
    { match = { title = "Picture-in-Picture" } },
    { match = { class = "xdg-desktop-portal-gtk" } },
}

for i, entry in ipairs(floating) do
    hl.window_rule({
        name  = "float-" .. i,
        match = entry.match,
        float = true,
        size  = entry.size,
    })
end

-- Screen annotation overlay (gromit-mpx / XWayland)
-- gromit-mpx creates X11 override-redirect windows, so it does NOT appear in
-- `hyprctl clients` and can't be tiled/floated via rules. BUT Hyprland still
-- applies per-window decoration effects (blur, dim, shadow) to the XWayland
-- surface, and that's exactly what makes strokes look blurry: Hyprland's
-- global blur reads through the transparent canvas. Disable those effects
-- explicitly so the overlay renders at 1:1 pixel fidelity.
hl.window_rule({
    name    = "gromit-crisp",
    match   = { class = "Gromit-mpx" },
    no_blur = true,
    no_dim  = true,
    no_anim = true,
})
