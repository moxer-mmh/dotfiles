local keymap = vim.keymap.set

local function map(mode, lhs, rhs, desc)
  local options = { noremap = true, silent = true }
  if desc then
    options.desc = desc
  end
  keymap(mode, lhs, rhs, options)
end


map("n", "<leader>nh", ":nohlsearch<CR>", "Clear search highlights")

map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to bottom window")
map("n", "<C-k>", "<C-w>k", "Move to top window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")

map("v", "J", ":m '>+1<CR>gv=gv", "Move text down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move text up")

map("x", "<leader>p", [["_dP]], "Paste without overwriting clipboard")

map({"n", "v"}, "<leader>d", [["_d]], "Delete to void register")

map({"n", "v"}, "<leader>y", [["+y]], "Copy to system clipboard")
map("n", "<leader>Y", [["+Y]], "Copy line to system clipboard")

map("n", "<leader>bd", ":bdelete<CR>", "Delete buffer")
map("n", "<leader>bn", ":bnext<CR>", "Next buffer")
map("n", "<leader>bp", ":bprevious<CR>", "Previous buffer")

map("n", "<leader>w", ":w<CR>", "Save file")
map("n", "<leader>q", ":q<CR>", "Quit")
map("n", "<leader>Q", ":qa<CR>", "Quit all")

map("n", "<C-Up>", ":resize -2<CR>", "Resize window up")
map("n", "<C-Down>", ":resize +2<CR>", "Resize window down")
map("n", "<C-Left>", ":vertical resize -2<CR>", "Resize window left")
map("n", "<C-Right>", ":vertical resize +2<CR>", "Resize window right")
