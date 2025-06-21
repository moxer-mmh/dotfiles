-- Treesitter configuration for syntax highlighting and parsing
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false, -- Load immediately, not lazily
  priority = 500, -- Load after colorscheme but early
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = false,
    },
    "HiPhish/rainbow-delimiters.nvim",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      auto_install = true, -- Auto-install missing parsers
      ensure_installed = {
        -- Languages you requested
        "python",
        "c",
        "java",
        "lua",
        "bash",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "javascript",
        "typescript",
        "rust",
        "go",
        "php",
        "yaml",
        "dockerfile",

        -- Additional useful parsers
        "json",
        "toml",
        "vim",
        "vimdoc",
        "gitignore",
        "sql",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true, -- Enable treesitter-based indenting
        -- Disable for specific languages if problematic
        disable = { "python" }, -- Python indenting can be tricky
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj
          keymaps = {
            -- Function text objects (using v for visual selection)
            ["vaf"] = "@function.outer",
            ["vif"] = "@function.inner",
            -- Class text objects
            ["vac"] = "@class.outer", 
            ["vic"] = "@class.inner",
            -- Parameter text objects
            ["vap"] = "@parameter.outer",
            ["vip"] = "@parameter.inner",
            -- Block text objects
            ["vab"] = "@block.outer",
            ["vib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Add jumps to jumplist
          goto_next_start = {
            ["<leader>nf"] = "@function.outer",  -- Next function
            ["<leader>nc"] = "@class.outer",     -- Next class
          },
          goto_next_end = {
            ["<leader>nF"] = "@function.outer",  -- Next function end
            ["<leader>nC"] = "@class.outer",     -- Next class end
          },
          goto_previous_start = {
            ["<leader>pf"] = "@function.outer",  -- Previous function
            ["<leader>pc"] = "@class.outer",     -- Previous class
          },
          goto_previous_end = {
            ["<leader>pF"] = "@function.outer",  -- Previous function end
            ["<leader>pC"] = "@class.outer",     -- Previous class end
          },
        },
      },
      rainbow = {
        enable = true,
        extended_mode = true,
      },
      autotag = {
        enable = true,
      },
    })
  end,
}
