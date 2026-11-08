-- Keybinds
--
-- Every bind carries a description ("[Section] what it does"). They are exposed
-- by `hyprctl binds -j`, which is what scripts/system/keybind-hints.sh reads, so
-- the hint menu always shows what is actually loaded.

local mainMod = "SUPER"
local dsp     = hl.dsp
local section = "General"

local GROMIT = "env GDK_BACKEND=x11 /usr/local/bin/gromit-mpx"
local SCRIPTS = "~/.config/hypr/scripts"

-- "SUPER + SHIFT" .. key, or the bare key when there are no modifiers
local function combo(mods, key)
    return mods == "" and key or (mods .. " + " .. key)
end

-- desc -> dispatcher, so keybind-hints.sh can run a bind picked from its menu:
--   hyprctl eval 'hl.dispatch(SPACE_STATION_BINDS["[Lock] Lock screen"])'
-- Rebuilt from scratch on every config load.
SPACE_STATION_BINDS = {}

-- Binds made inside a submap only make sense inside it, so they stay out of the
-- registry. hl.get_current_submap() reports the submap active at runtime, not
-- the one being defined, hence this flag.
local defining_submap = false

local function bind(mods, key, dispatcher, desc, opts)
    local options = {}
    for k, v in pairs(opts or {}) do
        options[k] = v
    end
    options.desc = "[" .. section .. "] " .. desc
    if not defining_submap and not options.mouse then
        SPACE_STATION_BINDS[options.desc] = dispatcher
    end
    return hl.bind(combo(mods, key), dispatcher, options)
end

local function run(cmd)
    return dsp.exec_cmd(cmd)
end

local M     = mainMod
local MS    = mainMod .. " + SHIFT"
local MC    = mainMod .. " + CTRL"
local MA    = mainMod .. " + ALT"

local LOCKED        = { locked = true }
local LOCKED_REPEAT = { locked = true, repeating = true }

-- AZERTY number row, in workspace order 1..10
local AZERTY_ROW = {
    "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft",
    "minus", "egrave", "underscore", "ccedilla", "agrave",
}

local function workspace_key(i)
    return tostring(i % 10) -- workspace 10 sits on key 0
end

-- ── App Launchers ──────────────────────────────────────────
section = "App Launchers"
bind(M,  "RETURN", run("kitty"), "Terminal")
bind(M,  "Q", dsp.window.close(), "Close window")
bind(MS, "Q", dsp.window.kill(), "Force kill window")
bind(M,  "E", run("nautilus"), "File manager")
bind(M,  "SPACE", run("rofi -show drun -theme ~/.config/rofi/space-station.rasi"), "App launcher")
bind(M,  "T", dsp.layout("togglesplit"), "Toggle split")
bind(M,  "F", dsp.window.fullscreen({ mode = "fullscreen" }), "Fullscreen")

bind(M,  "V", run("cliphist list | rofi -dmenu -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy"), "Clipboard history")
bind(MS, "V", dsp.window.float({ action = "toggle" }), "Toggle floating")

bind(M, "C", run("code"), "VS Code")
-- --remote-debugging-port lets Playwright/CDP attach to THIS window instead of
-- launching its own blank Chromium. Bound to 127.0.0.1 only. Trade-off: any local
-- process can then drive this browser and read its logged-in sessions.
bind(M, "B", run("brave --remote-debugging-port=9222"), "Brave")
bind(M, "S", run("spotify-launcher"), "Spotify")
bind(M, "O", run("obsidian"), "Obsidian")

-- ── Screenshots ────────────────────────────────────────────
section = "Screenshots"
bind(M,       "P",     run("hyprshot -m window"), "Window")
bind(MS,      "P",     run("hyprshot -m region"), "Region")
bind("",      "PRINT", run("hyprshot -m window"), "Window")
bind("SHIFT", "PRINT", run("hyprshot -m region"), "Region")
-- With cursor (grim -c), see ~/.local/bin/shot-cursor
bind("CTRL",         "PRINT", run("~/.local/bin/shot-cursor full"),   "Full screen with cursor")
bind("CTRL + SHIFT", "PRINT", run("~/.local/bin/shot-cursor region"), "Region with cursor")
bind("ALT",          "PRINT", run("~/.local/bin/shot-cursor delay"),  "Delayed with cursor")

-- ── Terminal/Dev ───────────────────────────────────────────
section = "Terminal/Dev"
bind(M,  "colon", run("kitty -e tmux new-session -d -s dev"), "tmux dev session")
bind(MS, "D",     run("kitty -e lazydocker"), "lazydocker")

-- ── Lock ───────────────────────────────────────────────────
section = "Lock"
bind(M, "X", run("hyprlock --immediate"), "Lock screen")

-- ── Focus / Move / Resize (vim keys + arrows) ──────────────
local directions = {
    { vim = "H", arrow = "left",  dir = "left",  dx = -20, dy = 0 },
    { vim = "L", arrow = "right", dir = "right", dx = 20,  dy = 0 },
    { vim = "K", arrow = "up",    dir = "up",    dx = 0,   dy = -20 },
    { vim = "J", arrow = "down",  dir = "down",  dx = 0,   dy = 20 },
}

for _, d in ipairs(directions) do
    for _, key in ipairs({ d.vim, d.arrow }) do
        section = "Focus Movement"
        bind(M, key, dsp.focus({ direction = d.dir }), "Focus " .. d.dir)
        section = "Move Windows"
        bind(MS, key, dsp.window.move({ direction = d.dir }), "Move window " .. d.dir)
        section = "Resize Windows"
        bind(MC, key, dsp.window.resize({ x = d.dx, y = d.dy, relative = true }), "Resize " .. d.dir)
    end
end

-- ── Cross-Monitor ──────────────────────────────────────────
section = "Cross-Monitor"
bind(MA, "H",     dsp.window.move({ monitor = "l" }), "Move window to left monitor")
bind(MA, "L",     dsp.window.move({ monitor = "r" }), "Move window to right monitor")
bind(MA, "left",  dsp.window.move({ monitor = "l" }), "Move window to left monitor")
bind(MA, "right", dsp.window.move({ monitor = "r" }), "Move window to right monitor")
bind(M,  "comma",  dsp.focus({ monitor = "l" }), "Focus left monitor")
bind(M,  "period", dsp.focus({ monitor = "r" }), "Focus right monitor")

-- ── Workspaces (AZERTY row + number fallback) ──────────────
section = "Workspaces"
for i = 1, 10 do
    for _, key in ipairs({ AZERTY_ROW[i], workspace_key(i) }) do
        bind(M, key, dsp.focus({ workspace = i }), "Go to workspace " .. i)
    end
end

for i = 1, 10 do
    for _, key in ipairs({ AZERTY_ROW[i], workspace_key(i) }) do
        section = "Move to Workspace"
        bind(MS, key, dsp.window.move({ workspace = i, follow = true }), "Move window to workspace " .. i)
    end
end

-- ── Mouse Binds ────────────────────────────────────────────
section = "Mouse"
bind(M, "mouse:272", dsp.window.drag(),   "Drag window",   { mouse = true })
bind(M, "mouse:273", dsp.window.resize(), "Resize window", { mouse = true })

-- ── Media / Hardware Keys ──────────────────────────────────
section = "Media"
bind("", "XF86AudioRaiseVolume", run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), "Volume up", LOCKED_REPEAT)
bind("", "XF86AudioLowerVolume", run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), "Volume down", LOCKED_REPEAT)
bind("", "XF86AudioMute",        run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), "Mute", LOCKED)

bind("", "XF86AudioPlay", run("playerctl play-pause"), "Play/pause", LOCKED)
bind("", "XF86AudioNext", run("playerctl next"),       "Next track", LOCKED)
bind("", "XF86AudioPrev", run("playerctl previous"),   "Previous track", LOCKED)

bind("", "XF86AudioMicMute", run("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), "Mute microphone", LOCKED)

bind("", "XF86MonBrightnessUp",   run("brightnessctl set 10%+"), "Brightness up", LOCKED_REPEAT)
bind("", "XF86MonBrightnessDown", run("brightnessctl set 10%-"), "Brightness down", LOCKED_REPEAT)

-- ── Camera Toggle ──────────────────────────────────────────
section = "Camera"
bind("", "XF86WebCam", run(SCRIPTS .. "/camera-toggle.sh"), "Toggle camera", LOCKED)
bind("", "F6",         run(SCRIPTS .. "/camera-toggle.sh"), "Toggle camera")
bind(M,  "F6",         run("cheese"), "Cheese")

-- ── Theme / Wallpaper ──────────────────────────────────────
section = "Theme/Wallpaper"
bind(MS, "T", run("~/.config/theme/scripts/theme-picker.sh"), "Theme picker")
bind(M,  "W", run(SCRIPTS .. "/wallpaper/wallpaper-picker.sh"), "Wallpaper picker")
bind(MS, "W", run("echo next > /tmp/wallpaper-daemon.pipe"), "Next wallpaper")
bind(MA, "W", run("echo toggle-pause > /tmp/wallpaper-daemon.pipe"), "Pause wallpaper rotation")

-- ── Waybar Dropdowns ───────────────────────────────────────
section = "Waybar"
bind(M, "G", run("~/.config/waybar/scripts/dropdown-system.sh"),   "System menu")
bind(M, "A", run("~/.config/waybar/scripts/dropdown-audio.sh"),    "Audio menu")
bind(M, "N", run("~/.config/waybar/scripts/dropdown-network.sh"),  "Network menu")
bind(M, "M", run("~/.config/waybar/scripts/dropdown-hardware.sh"), "Hardware menu")
bind(M, "D", run("swaync-client -t"), "Notifications")

-- ── Screen Annotation (gromit-mpx) ─────────────────────────
-- GDK_BACKEND=x11 required: gromit-mpx is X11-only, must run through Xwayland.
-- Explicit /usr/local/bin path targets the PATCHED binary (built from source
-- with opacity + antialiasing fixes); /usr/bin still has stock package.
--
-- Super+I toggles gromit AND enters the "draw" submap, where single letters
-- select tools (keyboard-only, no pad modifiers needed). Press I again (no
-- modifier) inside the submap to toggle off and exit. Press Escape to leave
-- the submap while keeping gromit active (useful if you need to type).
section = "Annotation"
bind(M,  "I", run(SCRIPTS .. "/gromit-enter.sh"), "Draw mode")
bind(M,  "Y", run(GROMIT .. " --visibility"), "Toggle annotations")
bind(M,  "U", run(GROMIT .. " --undo"), "Undo stroke")
bind(MS, "U", run(GROMIT .. " --redo"), "Redo stroke")
bind(MS, "I", run(GROMIT .. " --clear"), "Clear annotations")

-- Draw submap: single-key tool selection while gromit is active.
-- The submap captures ALL keystrokes system-wide, so mouse/pad drawing still
-- works but regular typing in other apps does NOT. Exit with Escape (keeps
-- gromit on) or I (toggles gromit off + exits submap).
defining_submap = true
hl.define_submap("draw", function()
    local tool = SCRIPTS .. "/gromit-tool.sh "
    section = "Draw mode"

    -- Paint-style composition: shape and color are independent selections.
    -- The tool script composes "{color} {shape}" from the persisted state
    -- files. Current state is shown in waybar.
    bind("", "R", run(tool .. "color red"),    "Red")
    bind("", "B", run(tool .. "color blue"),   "Blue")
    bind("", "Y", run(tool .. "color yellow"), "Yellow")
    bind("", "G", run(tool .. "color green"),  "Green")

    bind("", "P", run(tool .. "shape Pen"),             "Pen")
    bind("", "L", run(tool .. "shape Line"),            "Line")
    bind("", "T", run(tool .. "shape Rectangle"),       "Rectangle")
    bind("", "O", run(tool .. "shape Circle"),          "Circle")
    bind("", "F", run(tool .. 'shape "Filled Circle"'), "Filled circle")
    bind("", "S", run(tool .. "shape Smoothed"),        "Smoothed pen")

    -- Eraser (preserves shape/color state; next color/shape press exits eraser)
    bind("", "E", run(tool .. "eraser"), "Eraser")

    -- Undo / redo / clear / visibility stay accessible inside the submap
    bind("",      "U", run(GROMIT .. " --undo"),       "Undo stroke")
    bind("SHIFT", "U", run(GROMIT .. " --redo"),       "Redo stroke")
    bind("",      "X", run(GROMIT .. " --clear"),      "Clear annotations")
    bind("",      "V", run(GROMIT .. " --visibility"), "Toggle annotations")

    -- Keep workspace switching alive inside the draw submap, otherwise the
    -- user is trapped on the current workspace while annotating.
    for i = 1, 10 do
        bind(M, workspace_key(i), dsp.focus({ workspace = i }), "Go to workspace " .. i)
    end

    -- Leave submap, keep gromit canvas visible, hide waybar indicator.
    -- Uses a wrapper script so the indicator state-file is cleared atomically
    -- with the submap reset (a raw submap("reset") would leave the indicator up).
    bind("", "escape", run(SCRIPTS .. "/gromit-submap-leave.sh"), "Leave draw mode, keep canvas")
    -- Toggle gromit off AND exit submap in one atomic action
    bind("", "I", run(SCRIPTS .. "/gromit-exit.sh"), "Exit draw mode")
end)
defining_submap = false

-- ── System ─────────────────────────────────────────────────
section = "System"
bind(MS, "E",     run("~/.config/waybar/scripts/power.sh"), "Power menu")
bind(MS, "G",     run(SCRIPTS .. "/system/gamemode.sh"), "Game mode")
bind(MS, "M",     run(SCRIPTS .. "/system/display-mode.sh menu"), "Display mode (mirror/extend)")
bind(MS, "slash", run(SCRIPTS .. "/system/keybind-hints.sh"), "Keybind hints")
