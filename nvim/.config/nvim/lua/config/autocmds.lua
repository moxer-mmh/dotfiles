-- Auto commands and events
-- Custom autocmds go here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings group
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Don't auto comment new lines
autocmd("BufEnter", {
  group = general,
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.api.nvim_feedkeys("zz", "n", false)
    end
  end,
})

-- File-specific settings
local filetype_settings = augroup("FiletypeSettings", { clear = true })

-- Lua files
autocmd("FileType", {
  group = filetype_settings,
  pattern = "lua",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Python files
autocmd("FileType", {
  group = filetype_settings,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- JavaScript/TypeScript files
autocmd("FileType", {
  group = filetype_settings,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Go files
autocmd("FileType", {
  group = filetype_settings,
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false -- Go uses tabs
  end,
})

-- Treesitter-specific settings
local treesitter_group = augroup("TreesitterSettings", { clear = true })

-- Ensure treesitter highlighting is enabled for specific filetypes
autocmd("FileType", {
  group = treesitter_group,
  pattern = { "python", "javascript", "typescript", "lua", "bash", "c", "java", "rust", "go", "php", "html", "css", "yaml", "json" },
  callback = function()
    vim.cmd("TSBufEnable highlight")
  end,
})
