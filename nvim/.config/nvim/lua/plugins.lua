-- Plugin Specifications
-- This file defines all plugins to be loaded by the plugin manager
-- Each plugin category is organized in its own directory under plugins/

return {
  -- Core plugins (colorscheme, treesitter)
  { import = "plugins.core" },

  -- Editor enhancement plugins (telescope, harpoon, etc.)
  { import = "plugins.editor" },

  -- LSP and language support
  { import = "plugins.lsp" },

  -- Development tools (copilot, testing, etc.)
  { import = "plugins.dev" },

  -- UI enhancements (status line, file explorer, etc.)
  -- { import = "plugins.ui" },

  -- Utility plugins (formatting, linting, etc.)
  -- { import = "plugins.utils" },
}
