-- Telescope: Fuzzy finder for files, buffers, grep, etc.
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    }
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    
    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "%.lock",
          "__pycache__",
          "%.sqlite3",
          "%.ipynb",
          "vendor/*",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.svg",
          "%.otf",
          "%.ttf",
          "%.webp",
          "%.mp4",
          "%.mkv",
          "%.avi",
          "%.zip",
          "%.tar.gz",
          "%.tar.xz",
          "%.rar",
          "%.7z",
          -- Google Drive specific
          ".tmp.driveupload",
          ".tmp.drivedownload",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
          "--glob=!node_modules/",
          "--glob=!__pycache__/",
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- AZERTY friendly
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = false, -- Don't show hidden files by default
          follow = false, -- Don't follow symlinks (Google Drive issue)
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*" }
          end,
        },
      },
    })
    
    telescope.load_extension("fzf")
    
    -- AZERTY-friendly keymaps
    local keymap = vim.keymap.set
    local builtin = require("telescope.builtin")
    
    -- Smart file finder - chooses appropriate scope based on current directory
    keymap("n", "<leader>ff", function()
      local cwd = vim.fn.getcwd()
      local home = vim.fn.expand("~")
      
      -- If we're in home directory, search in a more focused way
      if cwd == home then
        builtin.find_files({
          cwd = cwd,
          hidden = false,
          search_dirs = { "Documents", "Downloads", "Desktop", ".config", "Projects" },
          prompt_title = "Find Files (Limited Scope)"
        })
      else
        -- If we're in a specific directory, search normally
        builtin.find_files({
          cwd = cwd,
          hidden = false,
        })
      end
    end, { desc = "Smart find files" })
    
    -- Project-aware grep
    keymap("n", "<leader>fg", function()
      local cwd = vim.fn.getcwd()
      local home = vim.fn.expand("~")
      
      if cwd == home then
        -- Search only in specific directories if in home
        builtin.live_grep({
          search_dirs = { "Documents", "Downloads", "Desktop", ".config" },
          prompt_title = "Live Grep (Limited Scope)"
        })
      else
        builtin.live_grep()
      end
    end, { desc = "Smart live grep" })
    
    -- Always search current buffer's directory
    keymap("n", "<leader>fF", function()
      local current_file = vim.fn.expand("%:p:h")
      builtin.find_files({
        cwd = current_file,
        prompt_title = "Files in Current Directory"
      })
    end, { desc = "Find in current file dir" })
    
    keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
    
    -- Quick directory navigation
    keymap("n", "<leader>fc", function()
      builtin.find_files({
        cwd = vim.fn.expand("~/.config/nvim"),
        prompt_title = "Neovim Config Files",
      })
    end, { desc = "Find config files" })
    
    keymap("n", "<leader>fd", function()
      builtin.find_files({
        cwd = vim.fn.expand("~/"),
        search_dirs = { "Documents", "Downloads", "Desktop" },
        prompt_title = "Home Files (Safe Dirs)",
      })
    end, { desc = "Find in safe home dirs" })
    
    -- Quick CD commands
    keymap("n", "<leader>fcd", function()
      local current_file_dir = vim.fn.expand("%:p:h")
      vim.cmd("cd " .. current_file_dir)
      print("Changed to: " .. current_file_dir)
    end, { desc = "CD to current file dir" })
    
    keymap("n", "<leader>fch", function()
      vim.cmd("cd ~")
      print("Changed to home directory")
    end, { desc = "CD to home" })
    
    keymap("n", "<leader>fcc", function()
      vim.cmd("cd ~/.config/nvim")
      print("Changed to nvim config")
    end, { desc = "CD to nvim config" })

    -- Debug helper
    keymap("n", "<leader>ft", function()
      print("Current working directory: " .. vim.fn.getcwd())
      print("File count in current dir: ")
      vim.cmd("!find . -maxdepth 1 -type f | wc -l")
    end, { desc = "Telescope debug info" })
  end,
}
