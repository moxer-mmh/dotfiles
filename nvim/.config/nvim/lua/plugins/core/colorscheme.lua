-- Colorscheme configuration
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000, -- Load before other plugins
  config = function()
    require("tokyonight").setup({
      style = "night", -- storm, moon, night, day
      transparent = false, -- Enable transparent background
      terminal_colors = true, -- Enable terminal colors
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark", -- style for sidebars
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the Day style
      hide_inactive_statusline = false, -- Hide inactive statuslines
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- bold headers in the lualine theme
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
