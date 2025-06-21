-- GitHub Copilot Integration
-- AI-powered code completion and suggestions

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Copilot settings
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    
    -- AZERTY-friendly keymaps
    local keymap = vim.keymap.set
    local opts = { silent = true }
    
    -- Accept suggestion with Ctrl+J (easier than Tab on AZERTY)
    keymap("i", "<C-j>", 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false })
    
    -- Navigate suggestions with Ctrl+N/P
    keymap("i", "<C-n>", "<Plug>(copilot-next)", opts)
    keymap("i", "<C-p>", "<Plug>(copilot-previous)", opts)
    
    -- Dismiss suggestion with Ctrl+E
    keymap("i", "<C-e>", "<Plug>(copilot-dismiss)", opts)
    
    -- Toggle Copilot (changed to avoid conflicts)
    keymap("n", "<leader>ai", ":Copilot toggle<CR>", { desc = "Toggle Copilot (AI)" })
    keymap("n", "<leader>as", ":Copilot status<CR>", { desc = "Copilot Status" })
    keymap("n", "<leader>ap", ":Copilot panel<CR>", { desc = "Copilot Panel" })
    keymap("n", "<leader>aa", ":Copilot setup<CR>", { desc = "Copilot Authentication" })
  end,
}
