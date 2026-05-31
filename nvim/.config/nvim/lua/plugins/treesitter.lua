return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	init = function()
		-- Parsers to keep installed (was previously auto_install on master).
		local ensure_installed = {
			"angular", "asm", "bash", "blade", "c", "c_sharp", "cmake", "comment",
			"cpp", "css", "csv", "cuda", "d", "dart", "diff", "disassembly",
			"dockerfile", "dot", "git_config", "git_rebase", "gitattributes",
			"gitcommit", "gitignore", "go", "gomod", "graphql", "html", "http",
			-- note: jsonc is not a separate parser on the main branch (uses json)
			"hyprlang", "ini", "java", "javascript", "jinja", "json",
			"kotlin", "lua", "make", "markdown", "markdown_inline", "mermaid",
			"nginx", "php", "powershell", "properties", "python", "rasi",
			"requirements", "ruby", "rust", "sql", "ssh_config", "tmux",
			"todotxt", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
		}

		-- Install only the parsers that aren't present yet. Guarded so a
		-- transient/missing-module state never hard-crashes startup.
		local ok, config = pcall(require, "nvim-treesitter.config")
		if ok then
			local already = config.get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(p)
					return not vim.tbl_contains(already, p)
				end)
				:totable()
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end
		end

		-- The main branch only installs parsers; we enable features ourselves.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
			callback = function(args)
				-- Highlighting (no-ops gracefully if no parser for this filetype).
				if not pcall(vim.treesitter.start) then
					return
				end
				-- Treesitter-based indentation.
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
