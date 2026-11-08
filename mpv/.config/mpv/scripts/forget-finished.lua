-- Forget the resume position once a file has been watched to the end.
--
-- With save-position-on-quit, a finished file is saved at its last frame.
-- Reopening it resumes at EOF, and uosc autoload then jumps straight to
-- another file in the folder, so the video looks like it skipped.
-- Resume still works for anything stopped part-way through.

-- Seconds before the end that already count as "watched".
local END_MARGIN = 1.0

local path = nil
local remaining = nil

mp.register_event("file-loaded", function()
    path = mp.get_property("path")
end)

mp.observe_property("time-remaining", "number", function(_, value)
    if value then remaining = value end
end)

-- mpv saves the position just before end-file, so deleting here wins.
-- Covers a natural EOF, uosc replacing the file (reason "stop") and quit.
mp.register_event("end-file", function()
    if path and remaining and remaining <= END_MARGIN then
        mp.commandv("delete-watch-later-config", path)
    end
    path, remaining = nil, nil
end)

-- Quit while paused on the last frame (keep-open): skip the save entirely.
mp.observe_property("eof-reached", "bool", function(_, eof)
    if eof then
        mp.set_property_bool("save-position-on-quit", false)
    elseif eof == false then
        -- Seeking back from the end makes the file resumable again. Ignore
        -- nil: it fires during quit, just before the position is written.
        mp.set_property_bool("save-position-on-quit", true)
    end
end)
