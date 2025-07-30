return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},

	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
      debug = true,
			sources = {
				null_ls.builtins.formatting.stylua,

				null_ls.builtins.formatting.prettier,
				require("none-ls.diagnostics.eslint_d"),

				null_ls.builtins.formatting.black,
				require("none-ls.diagnostics.ruff"),

				null_ls.builtins.formatting.goimports,
				null_ls.builtins.diagnostics.golangci_lint,

				null_ls.builtins.diagnostics.dotenv_linter.with({
					filetypes = { "dotenv"},
				}),

				null_ls.builtins.diagnostics.hadolint,
				null_ls.builtins.diagnostics.yamllint,

				null_ls.builtins.diagnostics.markdownlint,

        null_ls.builtins.formatting.shfmt,
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		vim.keymap.set("n", "<leader>od", vim.diagnostic.open_float)
	end,
}
