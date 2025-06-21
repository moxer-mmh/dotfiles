-- Plugin Manager Switching Utilities
-- This module provides functions to help migrate between different plugin managers

local M = {}

-- Function to generate Packer-style plugin specifications
function M.to_packer_format()
  print("To convert to Packer, you would:")
  print("1. Install Packer")
  print("2. Replace core/lazy.lua with packer setup")
  print("3. Convert plugin specs from lazy format to packer format")
  print("4. Use 'use' instead of plugin name as first element")
  
  -- Example conversion helper could be added here
end

-- Function to generate LazyVim compatible structure
function M.to_lazyvim_format()
  print("To convert to LazyVim:")
  print("1. Follow LazyVim installation guide")
  print("2. Move custom plugins to lua/plugins/")
  print("3. Keep config/ directory structure")
  print("4. Plugins are already in lazy.nvim format")
end

-- Function to backup current configuration
function M.backup_config()
  local backup_dir = vim.fn.stdpath("config") .. "_backup_" .. os.date("%Y%m%d_%H%M%S")
  print("Creating backup at: " .. backup_dir)
  vim.fn.system("cp -r " .. vim.fn.stdpath("config") .. " " .. backup_dir)
  print("Backup created successfully!")
  return backup_dir
end

-- Function to list all current plugins
function M.list_plugins()
  print("Current plugin structure:")
  print("Core plugins: colorscheme, treesitter")
  print("Editor plugins: oil, snacks, tmux-navigation")
  print("LSP plugins: lsp-config, completions")
  print("Dev plugins: copilot, vim-test, rails, swagger-preview, avante")
  print("Util plugins: none-ls")
end

return M
