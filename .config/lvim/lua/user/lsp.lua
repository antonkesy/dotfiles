vim.lsp.log_levels = 0
lvim.builtin.mason.on_config_done = function()
  local lspconfig = require("lspconfig")
  lspconfig.vale_ls.setup({
    single_file_support = true,
    filetypes = { "markdown", "tex", "text" },
    -- not working :/
    -- init_options = {
    -- configPath = vim.env.XDG_CONFIG_HOME .. "/vale/.vale.ini"
    -- },
  })
end

require("mason-lspconfig").setup_handlers({
  ["pyright"] = function()
    local lspconfig = require("lspconfig")
    lspconfig.pyright.setup({
      autoImportCompletion = true,
    })
    lspconfig.cmake.setup({})
  end,
})
