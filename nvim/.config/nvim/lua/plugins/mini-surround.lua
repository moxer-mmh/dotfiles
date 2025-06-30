return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require('mini.surround').setup({
      custom_surroundings = nil,
      highlight_duration = 500,
      mappings = {
        add = '<leader>sa',
      },
      n_lines = 20,
      respect_selection_type = false,
      search_method = 'cover',
      silent = false,
    })
  end
}
