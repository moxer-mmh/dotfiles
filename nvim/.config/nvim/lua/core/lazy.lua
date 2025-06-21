-- Lazy.nvim Plugin Manager Bootstrap
-- Simple, clean bootstrap without LazyVim dependency

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with our plugin specifications
require("lazy").setup({
  spec = {
    -- Import only our plugins.lua file (not auto-discover directories)
    require("plugins"),
  },
  defaults = {
    lazy = false, -- Plugins load on startup by default
    version = false, -- Don't use version tags
  },
  install = {
    colorscheme = { "tokyonight", "habamax" }, -- Fallback colorschemes
  },
  checker = {
    enabled = true, -- Check for plugin updates
    notify = false, -- Don't notify about updates
  },
  change_detection = {
    enabled = true, -- Watch for config changes
    notify = false, -- Don't notify about changes
  },
  ui = {
    border = "rounded", -- Prettier UI borders
  },
  performance = {
    rtp = {
      -- Disable some unused built-in plugins for better performance
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

