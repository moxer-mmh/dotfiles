-- Swagger API Preview
-- Preview Swagger/OpenAPI specifications in Neovim
-- Note: Requires npm permissions or local installation

return {
  "vinnymeller/swagger-preview.nvim",
  ft = { "yaml", "json" }, -- Load only for relevant filetypes
  build = function()
    -- Try global install first, fallback to local if permission denied
    local success = os.execute("npm install -g swagger-ui-watcher 2>/dev/null")
    if success ~= 0 then
      print("Note: Global npm install failed. You may need to install swagger-ui-watcher manually.")
      print("Run: npm install --prefix ~/.local swagger-ui-watcher")
    end
  end,
  config = function()
    -- Only configure if we can find swagger-ui-watcher
    local has_swagger = vim.fn.executable("swagger-ui-watcher") == 1
    if has_swagger then
      require("swagger-preview").setup()
    else
      vim.notify("swagger-ui-watcher not found. Swagger preview disabled.", vim.log.levels.WARN)
    end
  end,
}
