-- Animations
-- speed is in deciseconds: speed = 6 means 600 ms.

hl.config({ animations = { enabled = true } })

hl.curve("spaceOut",    { type = "bezier", points = { { 0.16, 1 },     { 0.3, 1 } } })
hl.curve("spaceIn",     { type = "bezier", points = { { 0.7, 0 },      { 0.84, 0 } } })
hl.curve("spaceBounce", { type = "bezier", points = { { 0.68, -0.55 }, { 0.265, 1.55 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "spaceOut" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4,  bezier = "spaceIn", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 12, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 6,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 8,  bezier = "spaceBounce", style = "slidevert" })
