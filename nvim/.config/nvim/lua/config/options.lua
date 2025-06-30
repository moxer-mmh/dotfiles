vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set smartindent")

vim.cmd("set number")
vim.cmd("set relativenumber")

vim.cmd("set cursorline")
vim.cmd("set nowrap")
vim.cmd("set scrolloff=8")
vim.cmd("set sidescrolloff=8")
vim.cmd("set signcolumn=yes")
vim.cmd("set termguicolors")
vim.cmd("set background=dark")
vim.cmd("set noshowmode ")

vim.cmd("set ignorecase")
vim.cmd("set smartcase")
vim.cmd("set hlsearch")
vim.cmd("set incsearch")

vim.cmd("set noswapfile")
vim.cmd("set nobackup")
vim.cmd("set nowritebackup")
vim.cmd("set undofile")
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"


vim.cmd("set updatetime=300")
vim.cmd("set timeoutlen=500")
vim.cmd("set mouse=a")
vim.cmd("set clipboard=unnamedplus")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.cmd("set completeopt=menuone,noselect")
vim.cmd("set pumheight=10")

vim.cmd("set lazyredraw")
vim.cmd("set hidden")

vim.cmd("set wildmenu")
