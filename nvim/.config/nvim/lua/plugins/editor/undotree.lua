-- Undotree: Visual undo history
return {
  "mbbill/undotree",
  config = function()
    -- AZERTY-friendly keymap
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
  end,
}
