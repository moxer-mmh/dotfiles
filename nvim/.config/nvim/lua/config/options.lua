-- Neovim options and settings
-- All vim options and global settings go here

-- Leader keys (moved to init.lua but kept here for reference)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- ==== INDENTATION AND TABS ====
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.tabstop = 2             -- Number of visual spaces per TAB
vim.opt.softtabstop = 2         -- Number of spaces in tab when editing
vim.opt.shiftwidth = 2          -- Spaces for autoindent
vim.opt.smartindent = true      -- Smart indenting

-- ==== LINE NUMBERS ====
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers

-- ==== VISUAL SETTINGS ====
vim.opt.cursorline = true       -- Highlight current line
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.scrolloff = 8           -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8       -- Keep 8 columns left/right of cursor
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.colorcolumn = "80"      -- Show column at 80 characters
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors

-- ==== SEARCH SETTINGS ====
vim.opt.ignorecase = true       -- Ignore case in search
vim.opt.smartcase = true        -- Smart case matching
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.incsearch = true        -- Incremental search

-- ==== FILE MANAGEMENT ====
vim.opt.swapfile = false        -- Disable swap files
vim.opt.backup = false          -- Disable backup files
vim.opt.writebackup = false     -- Disable backup during write
vim.opt.undofile = true         -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- ==== BEHAVIOR ====
vim.opt.updatetime = 250        -- Faster completion
vim.opt.timeoutlen = 300        -- Faster key sequence timeout
vim.opt.mouse = "a"             -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- ==== SPLIT BEHAVIOR ====
vim.opt.splitbelow = true       -- Open horizontal splits below
vim.opt.splitright = true       -- Open vertical splits to the right

-- ==== COMPLETION ====
vim.opt.completeopt = "menuone,noselect" -- Better completion experience
vim.opt.pumheight = 10          -- Popup menu height

-- ==== PERFORMANCE ====
vim.opt.lazyredraw = true       -- Don't redraw during macros
vim.opt.hidden = true           -- Enable background buffers
