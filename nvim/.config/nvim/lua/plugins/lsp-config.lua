return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			auto_install = true,
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"pyright",
					"gopls",
					"dockerls",
					"yamlls",
					"marksman",
					"jsonls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- capabilities (with nvim-cmp)
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- keep your encoding override if you need UTF-16 (e.g. some TS plugins/tools)
			capabilities.positionEncoding = { "utf-16" }

			-- Per-server configs (formerly lspconfig.<server>.setup({...}))
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
			})

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("pyright", {
				capabilities = capabilities,
			})

			vim.lsp.config("gopls", {
				capabilities = capabilities,
			})

			vim.lsp.config("dockerls", {
				capabilities = capabilities,
			})

			vim.lsp.config("yamlls", {
				capabilities = capabilities,
				settings = {
					yaml = {
						keyOrdering = false,
						schemas = {
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
						},
					},
				},
			})

			vim.lsp.config("marksman", {
				capabilities = capabilities,
			})

			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = {
							{
								fileMatch = { "components*.json" },
								url = "https://ui.shadcn.com/schema.json",
							},
							{
								fileMatch = { "package.json" },
								url = "https://json.schemastore.org/package.json",
							},
						},
					},
				},
			})

			-- Enable them (auto-start per filetype)
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"pyright",
				"gopls",
				"dockerls",
				"yamlls",
				"marksman",
				"jsonls",
			})

			-- Keymaps (unchanged)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>fa", vim.lsp.buf.code_action, { desc = "Code Action" })
		end,
	},
}
