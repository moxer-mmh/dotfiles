
-- Configuration Module Loader
-- This file loads all configuration modules in the correct order
-- Modify loading order here if needed

-- Load core settings first
require("config.options")

-- Load default keymaps (should be loaded after options)
require("config.keymaps")

-- Load autocommands last
require("config.autocmds")

-- Load custom keymaps (user overrides)
-- Comment out the next line if you don't want custom keymaps
pcall(require, "config.custom_keymaps")
