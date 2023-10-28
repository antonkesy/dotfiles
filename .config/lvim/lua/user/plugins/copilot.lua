return { {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup()
  end,
},
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()

      lvim.builtin.which_key.mappings["a"] = {
        name = "AI",
        e = { "<cmd>::Copilot enable<cr>", "Enable Copilot" },
        d = { "<cmd>::Copilot disable<cr>", "Disable Copilot" },
        s = { "<cmd>:Copilot status<CR>", "Copilot status" },
        p = { "<cmd>:Copilot panel<CR>", "Copilot panel" },
      }

      local capabilities = require("lvim.lsp").common_capabilities()
      capabilities.offsetEncoding = { "utf-16" }

      local clangd_flags = {
        capabilities = capabilities,
        "--fallback-style=google",
        "--background-index",
        "-j=12",
        "--all-scopes-completion",
        "--pch-storage=disk",
        "--clang-tidy",
        "--log=error",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        "--enable-config",
        "--offset-encoding=utf-16",
        "--ranking-model=heuristics",
      }

      require("lspconfig").clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "clangd", unpack(clangd_flags) },
      }

      -- TODO: fix keymaps - https://github.com/zbirenbaum/copilot.lua
      -- vim.api.nvim_set_keymap('i', '<m-g>', '<Plug>(copilot.suggest)', { silent = true })
      -- vim.api.nvim_set_keymap('i', '<m-h>', '<Plug>(copilot.previous)', { silent = true })
      -- vim.api.nvim_set_keymap('i', '<m-l>', '<Plug>(copilot.suggestions)', { silent = true })
      -- vim.api.nvim_set_keymap('i', '<m-n>', '<Plug>(copilot-dismiss)', { silent = true })
      -- vim.api.nvim_set_keymap('i', '<m-p>', '<cmd>:Copilot panel<CR>', { silent = true })
      -- vim.keymap.set('i', '<m-y>', function() return vim.fn['copilot#Accept']() end,
      --   { noremap = true, silent = true, expr = true, replace_keycodes = false })
    end
  }
}
