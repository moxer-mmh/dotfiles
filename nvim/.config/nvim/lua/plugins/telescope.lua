return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({

				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git",
						"dist",
						"build",
						"vendor",
						"target",
						"%.lock",
						"%.log",
						"%.cache",
						"%.tmp",
						"%.swp",
						"%.swo",
						"%.bak",
						"%.class",
						"%.jar",
						".obsidian",
						"99 - SYSTEM/",
						".trash",
					},

					prompt_prefix = "🔍 ",
					selection_caret = "➤ ",
					entry_prefix = "  ",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = { width = 0.9, height = 0.8, preview_width = 0.6 },
						vertical = { width = 0.9, height = 0.8, preview_height = 0.6 },
					},

					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
							["<C-h>"] = "which_key", -- see available actions
						},
					},
				},

				pickers = {
					find_files = {
						hidden = true,
					},
				},
			})

			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({
					hidden = true,
				})
			end, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
