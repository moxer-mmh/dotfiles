return {
	{
		"dlants/magenta.nvim",
		cmd = { "MagentaAsk", "MagentaRun", "MagentaLog" },
		opts = {
			transparency = true,
			observe = true,
			tools = {
				workspace = {
					type = "nvim_context",
					include_buffers = true,
					include_git = true,
					include_diagnostics = true,
				},
				opencode = {
					type = "http",
					endpoint = "http://127.0.0.1:4096",
					-- auth = os.getenv("OPENCODE_API_KEY"),
				},
			},
		},
		keys = {
			{ "<leader>ma", ":MagentaAsk<CR>", desc = "Ask Agent" },
			{ "<leader>mr", ":MagentaRun<CR>", desc = "Run Agent Task" },
			{ "<leader>ml", ":MagentaLog<CR>", desc = "Agent Log" },
		},
	},
}
