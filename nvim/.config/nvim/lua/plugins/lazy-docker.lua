return {
	"crnvl96/lazydocker.nvim",
	opts = {},
	config = function()
		require("lazydocker").setup({
			-- Default configuration
			require("lazydocker").setup({
				window = {
					settings = {
						width = 0.9,
						height = 0.9,
						border = "rounded",
						relative = "editor",
					},
				},
			}),
			vim.keymap.set({ "n", "t" }, "<leader>ld", "<Cmd>lua LazyDocker.toggle()<CR>"),
		})
	end,
}
