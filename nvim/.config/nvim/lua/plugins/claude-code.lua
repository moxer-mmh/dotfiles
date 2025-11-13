return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		log_level = "info",

		focus_after_send = false,

		track_selection = true,
		visual_demotion_delay_ms = 50,

		terminal = {
			split_side = "right",
			split_width_percentage = 0.33,
			provider = "auto",
			auto_close = true,
			snacks_win_opts = {},
		},
		diff_opts = {
			auto_close_on_accept = true,
			keep_terminal_focus = true,
		},
	},
	keys = {
		{ "<leader>c", nil, desc = "Claude AI" },
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Model" },
		{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
		{ "<leader>cn", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
	},
}
