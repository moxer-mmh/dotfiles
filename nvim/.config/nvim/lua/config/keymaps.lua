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

map("n", "<C-M-h>", ":vertical resize -2<CR>", "Resize window left")
map("n", "<C-M-l>", ":vertical resize +2<CR>", "Resize window right")
map("n", "<C-M-j>", ":resize +2<CR>", "Resize window down")
map("n", "<C-M-k>", ":resize -2<CR>", "Resize window up")
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")

map("v", "J", ":m '>+1<CR>gv=gv", "Move text down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move text up")

map("x", "<leader>p", [["_dP]], "Paste without overwriting clipboard")

map({ "n", "v" }, "<leader>d", [["_d]], "Delete to void register")

map({ "n", "v" }, "<leader>y", [["+y]], "Copy to system clipboard")
map("n", "<leader>Y", [["+Y]], "Copy line to system clipboard")

map("n", "<leader>bd", ":bdelete<CR>", "Delete buffer")
map("n", "<leader>bn", ":bnext<CR>", "Next buffer")
map("n", "<leader>bp", ":bprevious<CR>", "Previous buffer")

map("n", "<leader>w", ":w<CR>", "Save file")
map("n", "<leader>q", ":q<CR>", "Quit")
map("n", "<leader>Q", ":qa<CR>", "Quit all")

map("n", "<leader>r", "<C-r>", "Redo")

map("n", "<leader>ft", "za", "Toggle fold")
map("n", "<leader>fo", "zR", "Open all folds")
map("n", "<leader>fc", "zM", "Close all folds")
map("n", "<leader>fj", "zj", "Jump to next fold")
map("n", "<leader>fk", "zk", "Jump to previous fold")

map("t", "<C-\\>", "<C-\\><C-n>", "Exit terminal mode")
map("t", "<C-h>", "<C-\\><C-n><C-w>h", "Move left from terminal")
map("t", "<C-j>", "<C-\\><C-n><C-w>j", "Move down from terminal")
map("t", "<C-k>", "<C-\\><C-n><C-w>k", "Move up from terminal")
map("t", "<C-l>", "<C-\\><C-n><C-w>l", "Move right from terminal")

map("t", "<C-M-h>", "<C-\\><C-n>:vertical resize +2<CR>", "Resize window left (terminal)")
map("t", "<C-M-l>", "<C-\\><C-n>:vertical resize -2<CR>", "Resize window right (terminal)")
map("t", "<C-M-j>", "<C-\\><C-n>:resize +2<CR>", "Resize window down (terminal)")
map("t", "<C-M-k>", "<C-\\><C-n>:resize -2<CR>", "Resize window up (terminal)")
