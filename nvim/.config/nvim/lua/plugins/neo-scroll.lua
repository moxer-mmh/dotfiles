return {
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup({
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = false,
			cursor_scrolls_alone = true,
			easing_function = nil,
			pre_hook = nil,
			post_hook = nil,
			duration_multiplier = 1.0,
			easing = "linear",
			performance_mode = false,
			ignored_events = {
				"WinScrolled",
				"CursorMoved",
			},
		})
	end,
}
