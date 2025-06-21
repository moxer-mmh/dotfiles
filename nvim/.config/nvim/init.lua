-- Entry point for Neovim configuration
-- This file bootstraps the entire configuration

-- Set leader keys early (before any plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap Lazy.nvim plugin manager
require("core.lazy")

-- Load core configuration modules
require("config")
