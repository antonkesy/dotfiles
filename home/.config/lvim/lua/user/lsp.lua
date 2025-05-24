vim.lsp.log_levels = 0
lvim.builtin.mason.on_config_done = function()
  require("mason-lspconfig").setup {
    automatic_installation = true,
    -- TODO: add all
    ensure_installed = {
      "buf",
      "buildifier",
      "checkstyle",
      "cmake",
      -- "flake8",
      "jsonlint",
      "shellcheck",
      "lua_ls",
      "rust_analyzer",
      "clangd"
    },
  }
end



-- TODO: overwriting these deletes lvim default config
require("mason-lspconfig").setup_handlers({
  ["pyright"] = function()
    local lspconfig = require("lspconfig")
    lspconfig.pyright.setup({
      autoImportCompletion = true,
      typeCheckingMode = "strict",
      autoSearchPaths = true,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
    })
  end
})
