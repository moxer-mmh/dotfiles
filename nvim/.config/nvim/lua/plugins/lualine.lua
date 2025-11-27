return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- Custom Cyberpunk Theme for Lualine
		local colors = {
			bg = "#1a1a2e",
			bg_alt = "#16213e",
			fg = "#00ff88",
			green = "#00ff88",
			green_bright = "#44ff88",
			cyan = "#00aaff",
			cyan_bright = "#44ccff",
			blue = "#8844ff",
			purple = "#aa66ff",
			magenta = "#ff44aa",
			red = "#ff0088",
			red_bright = "#ff4488",
			orange = "#ffaa00",
			yellow = "#ffcc44",
			gray = "#6c7086",
			gray_dark = "#45475a",
		}

		local cyberpunk_theme = {
			normal = {
				a = { fg = colors.bg, bg = colors.green, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg_alt },
				c = { fg = colors.cyan, bg = colors.bg },
			},
			insert = {
				a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg_alt },
				c = { fg = colors.cyan, bg = colors.bg },
			},
			visual = {
				a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg_alt },
				c = { fg = colors.cyan, bg = colors.bg },
			},
			replace = {
				a = { fg = colors.bg, bg = colors.red, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg_alt },
				c = { fg = colors.cyan, bg = colors.bg },
			},
			command = {
				a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg_alt },
				c = { fg = colors.cyan, bg = colors.bg },
			},
			inactive = {
				a = { fg = colors.gray, bg = colors.bg },
				b = { fg = colors.gray_dark, bg = colors.bg },
				c = { fg = colors.gray_dark, bg = colors.bg },
			},
		}

		require("lualine").setup({
			options = {
				theme = cyberpunk_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				refresh = {
					statusline = 1000,
				},
			},
			sections = {
				lualine_a = { { "mode", fmt = function(str)
					return str:sub(1, 1)
				end } },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{ "filename", path = 1, color = { fg = colors.cyan_bright, gui = "bold" } },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
						diagnostics_color = {
							error = { fg = colors.red_bright },
							warn = { fg = colors.yellow },
							info = { fg = colors.cyan },
							hint = { fg = colors.green_bright },
						},
					},
					{ "filetype", icon_only = true },
					{ "encoding", color = { fg = colors.gray } },
					{ "fileformat", color = { fg = colors.gray } },
				},
				lualine_y = { { "progress", color = { fg = colors.magenta } } },
				lualine_z = { { "location", color = { fg = colors.bg, bg = colors.cyan, gui = "bold" } } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
