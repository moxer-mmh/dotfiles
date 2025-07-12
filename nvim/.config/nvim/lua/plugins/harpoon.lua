return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap.set
    keymap("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
    keymap("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

    keymap("n", "<leader>h&", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
    keymap("n", "<leader>hé", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
    keymap("n", "<leader>h\"", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
    keymap("n", "<leader>h'", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    keymap("n", "<leader>h(", function() harpoon:list():select(5) end, { desc = "Harpoon file 5" })
    keymap("n", "<leader>h-", function() harpoon:list():select(6) end, { desc = "Harpoon file 6" })
    keymap("n", "<leader>hè", function() harpoon:list():select(7) end, { desc = "Harpoon file 7" })
    keymap("n", "<leader>h_", function() harpoon:list():select(8) end, { desc = "Harpoon file 8" })
    keymap("n", "<leader>hç", function() harpoon:list():select(9) end, { desc = "Harpoon file 9" })
    keymap("n", "<leader>hà", function() harpoon:list():select(10) end, { desc = "Harpoon file 10" })
    keymap("n", "<leader>h)", function() harpoon:list():select(11) end, { desc = "Harpoon file 11" })
    keymap("n", "<leader>h=", function() harpoon:list():select(12) end, { desc = "Harpoon file 12" })

    keymap("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon previous" })
    keymap("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
  end,
}
