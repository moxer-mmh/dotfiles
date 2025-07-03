return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      proxy = nil,
      allow_insecure = false,

      system_prompt = "You are an AI programming assistant specialized in helping with code development.",
      model = "claude-sonnet-4",
      temperature = 0.1,

      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      separator = "---",

      show_folds = true,
      show_help = true,
      auto_follow_cursor = true,
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,
      highlight_selection = true,

      context = nil,
      history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
      callback = nil,

      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.line(source)
      end,

      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
          callback = function(response, source)
            -- Add your callback logic here if needed
          end,
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Please generate tests for my code.",
        },
        FixDiagnostic = {
          prompt = "Please assist with the following diagnostic issue in file:",
          selection = function(source)
            return require("CopilotChat.select").diagnostics(source)
          end,
        },
        Commit = {
          prompt =
          "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt =
          "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source, true)
          end,
        },
      },

      window = {
        layout = "vertical",
        width = 0.5,
        height = 0.5,
        relative = "editor",
        border = "single",
        row = nil,
        col = nil,
        title = "Copilot Chat",
        footer = nil,
        zindex = 1,
      },

      mappings = {
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-r>",
          insert = "<C-r>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-m>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        yank_diff = {
          normal = "gy",
        },
        show_diff = {
          normal = "gd",
        },
        show_system_prompt = {
          normal = "gp",
        },
        show_user_selection = {
          normal = "gs",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)

      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "CopilotChat - Open in vertical split" })
      vim.keymap.set("v", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "CopilotChat - Open with selection" })
      vim.keymap.set("n", "<leader>cx", "<cmd>CopilotChatExplain<cr>", { desc = "CopilotChat - Explain code" })
      vim.keymap.set("n", "<leader>ct", "<cmd>CopilotChatTests<cr>", { desc = "CopilotChat - Generate tests" })
      vim.keymap.set("n", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "CopilotChat - Review code" })
      vim.keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "CopilotChat - Fix code" })
      vim.keymap.set("n", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "CopilotChat - Optimize code" })
      vim.keymap.set("n", "<leader>cd", "<cmd>CopilotChatDocs<cr>", { desc = "CopilotChat - Generate docs" })
      vim.keymap.set(
        "n",
        "<leader>cfd",
        "<cmd>CopilotChatFixDiagnostic<cr>",
        { desc = "CopilotChat - Fix diagnostic" }
      )
      vim.keymap.set(
        "n",
        "<leader>ccm",
        "<cmd>CopilotChatCommit<cr>",
        { desc = "CopilotChat - Generate commit message" }
      )
      vim.keymap.set(
        "n",
        "<leader>ccs",
        "<cmd>CopilotChatCommitStaged<cr>",
        { desc = "CopilotChat - Generate commit message for staged" }
      )
    end,
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatDebugInfo",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
    },
    keys = {
      { "<leader>cc",  mode = { "n", "v" }, desc = "CopilotChat - Toggle" },
      { "<leader>cx",  mode = "n",          desc = "CopilotChat - Explain code" },
      { "<leader>ct",  mode = "n",          desc = "CopilotChat - Generate tests" },
      { "<leader>cr",  mode = "n",          desc = "CopilotChat - Review code" },
      { "<leader>cf",  mode = "n",          desc = "CopilotChat - Fix code" },
      { "<leader>co",  mode = "n",          desc = "CopilotChat - Optimize code" },
      { "<leader>cd",  mode = "n",          desc = "CopilotChat - Generate docs" },
      { "<leader>cfd", mode = "n",          desc = "CopilotChat - Fix diagnostic" },
      { "<leader>ccm", mode = "n",          desc = "CopilotChat - Generate commit message" },
      { "<leader>ccs", mode = "n",          desc = "CopilotChat - Generate commit message for staged" },
    },
  },
}
