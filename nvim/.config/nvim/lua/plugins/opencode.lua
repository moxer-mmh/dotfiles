return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			vim.g.opencode_opts = {}

			vim.o.autoread = true

			-- Leader-based keymaps (cleaner for LazyVim)
			local map = vim.keymap.set
			map({ "n", "x" }, "<leader>oa", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask OpenCode" })

			map({ "n", "x" }, "<leader>os", function()
				require("opencode").select()
			end, { desc = "OpenCode Select" })

			map({ "n", "x" }, "<leader>op", function()
				require("opencode").prompt("@this")
			end, { desc = "Prompt OpenCode" })

			map("n", "<leader>oo", function()
				require("opencode").toggle()
			end, { desc = "Toggle OpenCode Panel" })

			map("n", "<leader>ou", function()
				require("opencode").command("messages_half_page_up")
			end, { desc = "OpenCode Messages Up" })

			map("n", "<leader>od", function()
				require("opencode").command("messages_half_page_down")
			end, { desc = "OpenCode Messages Down" })
		end,
	},
}
