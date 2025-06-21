return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {
        -- Your requested languages
        "pyright",        -- Python
        "clangd",         -- C/C++
        "lua_ls",         -- Lua
        "jdtls",           -- Java
        "bashls",         -- Bash/Shell
        "marksman",       -- Markdown
        "html",           -- HTML
        "cssls",          -- CSS
        "ts_ls",          -- JavaScript/TypeScript
        "rust_analyzer",  -- Rust
        "gopls",          -- Go
        "phpactor",       -- PHP
        "yamlls",         -- YAML
        "dockerls",       -- Docker
        -- Additional useful ones
        "jsonls",         -- JSON
        "taplo",          -- TOML
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      local lspconfig = require("lspconfig")

      -- Language server configurations
      local servers = {
        pyright = {},
        clangd = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        bashls = {},
        marksman = {},
        html = {},
        cssls = {},
        ts_ls = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
        gopls = {},
        phpactor = {},
        yamlls = {},
        dockerls = {},
        jsonls = {},
        taplo = {},
      }

      -- Setup each server
      for server, config in pairs(servers) do
        config.capabilities = capabilities

        -- Add error handling for problematic servers
        if server == "java_language_server" then
          config.handlers = {
            ["textDocument/hover"] = function(err, result, ctx, config)
              if err and err.message and err.message:match("uri.*is null") then
                -- Silently ignore URI null errors
                return
              end
              return vim.lsp.handlers["textDocument/hover"](err, result, ctx, config)
            end,
            ["textDocument/signatureHelp"] = function(err, result, ctx, config)
              if err and err.message and err.message:match("uri.*is null") then
                -- Silently ignore URI null errors
                return
              end
              return vim.lsp.handlers["textDocument/signatureHelp"](err, result, ctx, config)
            end,
          }
        end

        lspconfig[server].setup(config)
      end

      -- AZERTY-friendly LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local keymap = vim.keymap.set

          -- Navigation
          keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          keymap("n", "gr", function() require("telescope.builtin").lsp_references() end, vim.tbl_extend("force", opts, { desc = "Show references (Telescope)" }))

          -- Information
          keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          keymap("n", "<leader>sh", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

          -- Actions
          keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
          keymap("n", "<leader>cf", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format code" }))

          -- Diagnostics (AZERTY friendly)
          keymap("n", "<leader>do", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Open diagnostic float" }))
          keymap("n", "<leader>dn", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          keymap("n", "<leader>dp", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          keymap("n", "<leader>dl", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostic loclist" }))
        end,
      })

      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
