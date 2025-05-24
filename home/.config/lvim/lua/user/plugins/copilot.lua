return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-y>",
            accept_word = false,
            accept_line = false,
            next = "<M-l>",
            prev = "<M-h>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
          gitcommit = true,
          gitrebase = true,
          hgcommit = true,
          svn = true,
          cvs = false,
          ["."] = true,
        }
      })
      lvim.builtin.which_key.mappings["a"] = {
        name = "AI",
        e = { "<cmd>:Copilot enable<cr>", "Enable Copilot" },
        d = { "<cmd>:Copilot disable<cr>", "Disable Copilot" },
        s = { "<cmd>:Copilot status<CR>", "Copilot status" },
        p = { "<cmd>:Copilot panel<CR>", "Copilot panel" },
      }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      lvim.builtin.which_key.mappings["a"].o = {
        "<cmd>:CopilotChatOpen<cr>", "Open CopilotChat",
      }
    end,
  }
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     local cmp = require("copilot_cmp")
  --     cmp.setup()

  --     local capabilities = require("lvim.lsp").common_capabilities()
  --     capabilities.offsetEncoding = { "utf-16" }

  --     local clangd_flags = {
  --       capabilities = capabilities,
  --       "--fallback-style=google",
  --       "--background-index",
  --       "-j=12",
  --       "--all-scopes-completion",
  --       "--pch-storage=disk",
  --       "--clang-tidy",
  --       "--log=error",
  --       "--completion-style=detailed",
  --       "--header-insertion=iwyu",
  --       "--header-insertion-decorators",
  --       "--enable-config",
  --       "--offset-encoding=utf-16",
  --       "--ranking-model=heuristics",
  --     }

  --     require("lspconfig").clangd.setup {
  --       on_attach = on_attach,
  --       capabilities = capabilities,
  --       cmd = { "clangd", unpack(clangd_flags) },
  --     }

  --     -- Tab Completion Configuration from https://github.com/zbirenbaum/copilot-cmp
  --     local has_words_before = function()
  --       if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  --       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --       return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  --     end
  --     cmp.setup({
  --       mapping = {
  --         ["<Tab>"] = vim.schedule_wrap(function(fallback)
  --           if cmp.visible() and has_words_before() then
  --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  --           else
  --             fallback()
  --           end
  --         end),
  --       },
  --     })
  --   end
  -- }
}
