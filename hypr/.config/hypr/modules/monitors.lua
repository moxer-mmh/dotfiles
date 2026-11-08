-- Monitors
--
-- The external display (datashow) is either extended or mirrored. The choice is
-- made by scripts/system/display-mode.sh, which writes it to a state file and
-- triggers a reload. This module reads that file on every load, so the choice
-- survives reloads (theme changes trigger one) without any extra hook.

local internal = {
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
}

local external = {
    output   = "HDMI-A-1",
    mode     = "1280x720@60",
    position = "1920x0",
    scale    = 1,
}

local function display_mode()
    local state_home = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
    local file = io.open(state_home .. "/hypr/display-mode", "r")
    if not file then
        return "extend"
    end
    local value = file:read("l")
    file:close()
    return value == "mirror" and "mirror" or "extend"
end

hl.monitor(internal)

if display_mode() == "mirror" then
    hl.monitor({
        output   = external.output,
        mode     = external.mode,
        position = "auto",
        scale    = external.scale,
        mirror   = internal.output,
    })
else
    hl.monitor(external)
end
