-- Custom Keymaps
-- Add your own custom keymaps here
-- This file is loaded after all plugin configurations

local keymap = vim.keymap.set
local opts = { silent = true }

-- Example custom keymaps (uncomment and modify as needed):

-- Quick save and quit
-- keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
-- keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Buffer navigation
-- keymap("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- keymap("n", "<leader>bp", ":bprev<CR>", { desc = "Previous buffer" })

-- Window navigation (AZERTY-friendly)
-- keymap("n", "<A-h>", "<C-w>h", { desc = "Move to left window" })
-- keymap("n", "<A-j>", "<C-w>j", { desc = "Move to bottom window" })
-- keymap("n", "<A-k>", "<C-w>k", { desc = "Move to top window" })
-- keymap("n", "<A-l>", "<C-w>l", { desc = "Move to right window" })

-- Terminal toggle
-- keymap("n", "<leader>t", ":terminal<CR>", { desc = "Open terminal" })

-- Custom functions (add your own here)
-- Example: Toggle line numbers
-- local function toggle_line_numbers()
--   vim.wo.number = not vim.wo.number
--   vim.wo.relativenumber = not vim.wo.relativenumber
-- end
-- keymap("n", "<leader>ln", toggle_line_numbers, { desc = "Toggle line numbers" })

-- Add more custom keymaps below:
