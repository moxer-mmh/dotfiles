vim.g.mapleader = " "

local opt = vim.opt

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.background = "dark"
opt.showmode = false
opt.wildmenu = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

opt.updatetime = 300
opt.timeoutlen = 500
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.splitbelow = true
opt.splitright = true

opt.completeopt = { "menuone", "noselect" }
opt.pumheight = 10

opt.lazyredraw = true
opt.hidden = true
