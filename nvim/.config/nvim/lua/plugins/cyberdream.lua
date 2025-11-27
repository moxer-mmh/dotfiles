return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	name = "cyberdream",
	priority = 1000,
	config = function()
		-- Color Palette - Cyberpunk Theme
		local colors = {
			-- Backgrounds
			bg = "#1a1a2e", -- VOID_BLACK
			bg_dark = "#0f0f1a", -- Darker for contrast
			bg_highlight = "#16213e", -- DEEP_PURPLE
			bg_alt = "#1e1e2e",
			bg_visual = "#5a2a40",

			-- Foregrounds
			fg = "#00ff88", -- Neon green primary
			fg_alt = "#cdd6f4", -- Light gray for readability
			fg_dark = "#9399b2",

			-- Accent colors
			green = "#00ff88",
			green_bright = "#44ff88",
			cyan = "#00aaff",
			cyan_bright = "#44ccff",
			blue = "#8844ff",
			purple = "#aa66ff",
			magenta = "#ff44aa",
			pink = "#ff66cc",
			red = "#ff0088",
			red_bright = "#ff4488",
			orange = "#ffaa00",
			yellow = "#ffcc44",

			-- Grays
			gray = "#6c7086",
			gray_dark = "#45475a",
			gray_light = "#9399b2",

			-- Special
			none = "NONE",
		}

		require("cyberdream").setup({
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = { bold = true },
				variables = {},
				sidebars = "dark",
				floats = "dark",
			},
			sidebars = { "qf", "help" },
			day_brightness = 0.3,
			hide_inactive_statusline = false,
			dim_inactive = false,
			lualine_bold = true,
			colors = {
				bg = colors.bg,
				fg = colors.fg,
				cyan = colors.cyan,
				green = colors.green,
				orange = colors.orange,
				pink = colors.magenta,
				purple = colors.blue,
				red = colors.red,
				yellow = colors.yellow,
				grey = colors.gray,
				bgAlt = colors.bg_alt,
				bgHighlight = colors.bg_highlight,
			},
		})
		vim.cmd.colorscheme("cyberdream")

		-- Comprehensive highlight overrides
		local function set_hl(group, opts)
			vim.api.nvim_set_hl(0, group, opts)
		end

		-- ===== BASE UI ELEMENTS =====
		set_hl("Normal", { fg = colors.fg, bg = colors.bg })
		set_hl("NormalFloat", { fg = colors.fg, bg = colors.bg })
		set_hl("FloatBorder", { fg = colors.blue, bg = colors.bg_highlight })
		set_hl("FloatTitle", { fg = colors.green, bg = colors.bg_highlight, bold = true })

		-- Cursor
		set_hl("Cursor", { fg = colors.bg, bg = colors.green })
		set_hl("lCursor", { fg = colors.bg, bg = colors.green })
		set_hl("CursorIM", { fg = colors.bg, bg = colors.green })
		set_hl("TermCursor", { fg = colors.bg, bg = colors.green })
		set_hl("TermCursorNC", { fg = colors.bg, bg = colors.gray })

		-- Lines and columns
		set_hl("CursorLine", { bg = colors.bg_highlight })
		set_hl("CursorColumn", { bg = colors.bg_highlight })
		set_hl("ColorColumn", { bg = colors.bg_highlight })
		set_hl("CursorLineNr", { fg = colors.green, bg = colors.bg_highlight, bold = true })
		set_hl("LineNr", { fg = colors.gray_dark })
		set_hl("SignColumn", { bg = colors.bg })
		set_hl("FoldColumn", { fg = colors.gray, bg = colors.bg })

		-- Visual selection
		set_hl("Visual", { bg = colors.bg_visual })
		set_hl("VisualNOS", { bg = colors.bg_visual })

		-- Search
		set_hl("Search", { fg = colors.bg, bg = colors.yellow, bold = true })
		set_hl("IncSearch", { fg = colors.bg, bg = colors.magenta, bold = true })
		set_hl("CurSearch", { fg = colors.bg, bg = colors.cyan_bright, bold = true })
		set_hl("Substitute", { fg = colors.bg, bg = colors.red, bold = true })

		-- ===== SYNTAX HIGHLIGHTING =====
		-- Comments
		set_hl("Comment", { fg = colors.gray, italic = true })
		set_hl("SpecialComment", { fg = colors.gray_light, italic = true })

		-- Constants
		set_hl("Constant", { fg = colors.orange })
		set_hl("String", { fg = colors.green_bright })
		set_hl("Character", { fg = colors.green_bright })
		set_hl("Number", { fg = colors.orange })
		set_hl("Boolean", { fg = colors.orange, bold = true })
		set_hl("Float", { fg = colors.orange })

		-- Identifiers
		set_hl("Identifier", { fg = colors.cyan })
		set_hl("Function", { fg = colors.blue, bold = true })

		-- Statements
		set_hl("Statement", { fg = colors.magenta })
		set_hl("Conditional", { fg = colors.magenta, italic = true })
		set_hl("Repeat", { fg = colors.magenta, italic = true })
		set_hl("Label", { fg = colors.magenta })
		set_hl("Operator", { fg = colors.cyan_bright })
		set_hl("Keyword", { fg = colors.red, italic = true, bold = true })
		set_hl("Exception", { fg = colors.red, bold = true })

		-- PreProc
		set_hl("PreProc", { fg = colors.yellow })
		set_hl("Include", { fg = colors.yellow })
		set_hl("Define", { fg = colors.yellow })
		set_hl("Macro", { fg = colors.yellow })
		set_hl("PreCondit", { fg = colors.yellow })

		-- Types
		set_hl("Type", { fg = colors.blue })
		set_hl("StorageClass", { fg = colors.blue, italic = true })
		set_hl("Structure", { fg = colors.blue })
		set_hl("Typedef", { fg = colors.blue })

		-- Special
		set_hl("Special", { fg = colors.pink })
		set_hl("SpecialChar", { fg = colors.pink })
		set_hl("Tag", { fg = colors.cyan })
		set_hl("Delimiter", { fg = colors.fg_alt })
		set_hl("Debug", { fg = colors.red })

		-- ===== TREESITTER HIGHLIGHTS =====
		-- Keywords
		set_hl("@keyword", { fg = colors.red, italic = true, bold = true })
		set_hl("@keyword.function", { fg = colors.red, italic = true })
		set_hl("@keyword.return", { fg = colors.magenta, italic = true })
		set_hl("@keyword.operator", { fg = colors.magenta })
		set_hl("@keyword.import", { fg = colors.yellow })

		-- Functions and methods
		set_hl("@function", { fg = colors.blue, bold = true })
		set_hl("@function.call", { fg = colors.blue })
		set_hl("@function.builtin", { fg = colors.purple })
		set_hl("@function.macro", { fg = colors.yellow })
		set_hl("@method", { fg = colors.blue, bold = true })
		set_hl("@method.call", { fg = colors.blue })
		set_hl("@constructor", { fg = colors.blue, bold = true })

		-- Variables
		set_hl("@variable", { fg = colors.fg })
		set_hl("@variable.builtin", { fg = colors.cyan_bright })
		set_hl("@variable.parameter", { fg = colors.cyan })
		set_hl("@variable.member", { fg = colors.cyan })

		-- Types
		set_hl("@type", { fg = colors.blue })
		set_hl("@type.builtin", { fg = colors.purple })
		set_hl("@type.definition", { fg = colors.blue })

		-- Strings
		set_hl("@string", { fg = colors.green_bright })
		set_hl("@string.escape", { fg = colors.yellow })
		set_hl("@string.special", { fg = colors.pink })

		-- Constants
		set_hl("@constant", { fg = colors.orange })
		set_hl("@constant.builtin", { fg = colors.orange, bold = true })
		set_hl("@constant.macro", { fg = colors.yellow })

		-- Numbers
		set_hl("@number", { fg = colors.orange })
		set_hl("@number.float", { fg = colors.orange })
		set_hl("@boolean", { fg = colors.orange, bold = true })

		-- Operators
		set_hl("@operator", { fg = colors.cyan_bright })
		set_hl("@punctuation.delimiter", { fg = colors.fg_alt })
		set_hl("@punctuation.bracket", { fg = colors.fg_alt })
		set_hl("@punctuation.special", { fg = colors.pink })

		-- Tags (HTML/JSX)
		set_hl("@tag", { fg = colors.blue })
		set_hl("@tag.attribute", { fg = colors.cyan })
		set_hl("@tag.delimiter", { fg = colors.fg_alt })

		-- Properties
		set_hl("@property", { fg = colors.cyan })
		set_hl("@field", { fg = colors.cyan })

		-- Other
		set_hl("@label", { fg = colors.magenta })
		set_hl("@namespace", { fg = colors.blue })
		set_hl("@module", { fg = colors.blue })

		-- ===== LSP & DIAGNOSTICS =====
		set_hl("DiagnosticError", { fg = colors.red_bright })
		set_hl("DiagnosticWarn", { fg = colors.yellow })
		set_hl("DiagnosticInfo", { fg = colors.cyan_bright })
		set_hl("DiagnosticHint", { fg = colors.green_bright })
		set_hl("DiagnosticOk", { fg = colors.green })

		-- Underlines
		set_hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.red_bright })
		set_hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
		set_hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.cyan })
		set_hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.green })

		-- LSP References
		set_hl("LspReferenceText", { bg = colors.bg_visual })
		set_hl("LspReferenceRead", { bg = colors.bg_visual })
		set_hl("LspReferenceWrite", { bg = colors.bg_visual, underline = true })

		-- ===== COMPLETION MENU (CMP) =====
		set_hl("Pmenu", { fg = colors.fg, bg = colors.bg_highlight })
		set_hl("PmenuSel", { fg = colors.bg, bg = colors.green, bold = true })
		set_hl("PmenuSbar", { bg = colors.bg_alt })
		set_hl("PmenuThumb", { bg = colors.blue })
		set_hl("PmenuKind", { fg = colors.blue, bg = colors.bg_highlight })
		set_hl("PmenuKindSel", { fg = colors.bg, bg = colors.green })
		set_hl("PmenuExtra", { fg = colors.gray, bg = colors.bg_highlight })
		set_hl("PmenuExtraSel", { fg = colors.bg, bg = colors.green })

		-- CMP specific
		set_hl("CmpItemAbbrDeprecated", { fg = colors.gray, strikethrough = true })
		set_hl("CmpItemAbbrMatch", { fg = colors.green, bold = true })
		set_hl("CmpItemAbbrMatchFuzzy", { fg = colors.green_bright, bold = true })
		set_hl("CmpItemKindVariable", { fg = colors.cyan })
		set_hl("CmpItemKindInterface", { fg = colors.blue })
		set_hl("CmpItemKindFunction", { fg = colors.blue })
		set_hl("CmpItemKindMethod", { fg = colors.blue })
		set_hl("CmpItemKindKeyword", { fg = colors.red })
		set_hl("CmpItemKindProperty", { fg = colors.cyan })
		set_hl("CmpItemKindUnit", { fg = colors.orange })

		-- ===== TELESCOPE =====
		set_hl("TelescopeBorder", { fg = colors.blue, bg = colors.bg_highlight })
		set_hl("TelescopeNormal", { fg = colors.fg, bg = colors.bg_highlight })
		set_hl("TelescopePromptNormal", { fg = colors.fg, bg = colors.bg_alt })
		set_hl("TelescopePromptBorder", { fg = colors.green, bg = colors.bg_alt })
		set_hl("TelescopePromptTitle", { fg = colors.bg, bg = colors.green, bold = true })
		set_hl("TelescopePreviewTitle", { fg = colors.bg, bg = colors.blue, bold = true })
		set_hl("TelescopeResultsTitle", { fg = colors.bg, bg = colors.cyan, bold = true })
		set_hl("TelescopeSelection", { fg = colors.green, bg = colors.bg_visual, bold = true })
		set_hl("TelescopeSelectionCaret", { fg = colors.green, bg = colors.bg_visual, bold = true })
		set_hl("TelescopeMatching", { fg = colors.yellow, bold = true })

		-- ===== NEO-TREE =====
		set_hl("NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
		set_hl("NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg_highlight })
		set_hl("NeoTreeDirectoryIcon", { fg = colors.blue })
		set_hl("NeoTreeDirectoryName", { fg = colors.cyan_bright })
		set_hl("NeoTreeFileName", { fg = colors.fg })
		set_hl("NeoTreeFileIcon", { fg = colors.fg_alt })
		set_hl("NeoTreeRootName", { fg = colors.green, bold = true })
		set_hl("NeoTreeFloatBorder", { fg = colors.blue, bg = colors.bg_highlight })
		set_hl("NeoTreeFloatTitle", { fg = colors.bg, bg = colors.blue, bold = true })
		set_hl("NeoTreeGitAdded", { fg = colors.green })
		set_hl("NeoTreeGitModified", { fg = colors.yellow })
		set_hl("NeoTreeGitDeleted", { fg = colors.red })
		set_hl("NeoTreeGitConflict", { fg = colors.red, bold = true })
		set_hl("NeoTreeGitUntracked", { fg = colors.gray })
		set_hl("NeoTreeIndentMarker", { fg = colors.gray_dark })
		set_hl("NeoTreeSymbolicLinkTarget", { fg = colors.cyan })

		-- ===== WHICH-KEY =====
		set_hl("WhichKey", { fg = colors.green, bold = true })
		set_hl("WhichKeyGroup", { fg = colors.blue })
		set_hl("WhichKeyDesc", { fg = colors.cyan })
		set_hl("WhichKeySeparator", { fg = colors.gray })
		set_hl("WhichKeyFloat", { bg = colors.bg_highlight })
		set_hl("WhichKeyBorder", { fg = colors.blue, bg = colors.bg_highlight })

		-- ===== GIT SIGNS =====
		set_hl("GitSignsAdd", { fg = colors.green })
		set_hl("GitSignsChange", { fg = colors.yellow })
		set_hl("GitSignsDelete", { fg = colors.red })
		set_hl("GitSignsAddLn", { fg = colors.green, bg = colors.bg_highlight })
		set_hl("GitSignsChangeLn", { fg = colors.yellow, bg = colors.bg_highlight })
		set_hl("GitSignsDeleteLn", { fg = colors.red, bg = colors.bg_highlight })

		-- Diff
		set_hl("DiffAdd", { fg = colors.green, bg = colors.bg_highlight })
		set_hl("DiffChange", { fg = colors.yellow, bg = colors.bg_highlight })
		set_hl("DiffDelete", { fg = colors.red, bg = colors.bg_highlight })
		set_hl("DiffText", { fg = colors.cyan, bg = colors.bg_visual, bold = true })

		-- ===== STATUSLINE & TABLINE =====
		set_hl("StatusLine", { fg = colors.fg, bg = colors.bg_alt })
		set_hl("StatusLineNC", { fg = colors.gray, bg = colors.bg_highlight })

		set_hl("TabLine", { fg = colors.gray, bg = colors.bg_alt })
		set_hl("TabLineFill", { bg = colors.bg })
		set_hl("TabLineSel", { fg = colors.bg, bg = colors.green, bold = true })

		-- ===== OTHER UI =====
		set_hl("WinSeparator", { fg = colors.gray_dark })
		set_hl("VertSplit", { fg = colors.gray_dark })

		set_hl("Directory", { fg = colors.cyan_bright, bold = true })
		set_hl("Title", { fg = colors.green, bold = true })

		set_hl("ErrorMsg", { fg = colors.red_bright, bold = true })
		set_hl("WarningMsg", { fg = colors.yellow, bold = true })
		set_hl("MoreMsg", { fg = colors.cyan_bright })
		set_hl("Question", { fg = colors.cyan })

		set_hl("MatchParen", { fg = colors.yellow, bg = colors.bg_visual, bold = true })
		set_hl("NonText", { fg = colors.gray_dark })
		set_hl("SpecialKey", { fg = colors.gray_dark })
		set_hl("Whitespace", { fg = colors.gray_dark })

		set_hl("Folded", { fg = colors.gray_light, bg = colors.bg_alt })
		set_hl("Conceal", { fg = colors.gray })

		-- Spell
		set_hl("SpellBad", { undercurl = true, sp = colors.red })
		set_hl("SpellCap", { undercurl = true, sp = colors.yellow })
		set_hl("SpellRare", { undercurl = true, sp = colors.cyan })
		set_hl("SpellLocal", { undercurl = true, sp = colors.green })
	end,
}
