lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup {
        timeout = 200, --ms
      }
    end,
  },
  {
    -- TODO: ignore nvim tree + map
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = nil,
        auto_session_use_git_branch = nil,

      }

      -- workaround nvim tree empty buffer after session restore
      local function restore_nvim_tree()
        require("nvim-tree.api").tree.open({ focus = false })
        require("nvim-tree.api").tree.close()
      end

      require('auto-session').setup {
        post_restore_cmds = { restore_nvim_tree }
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  {
    -- TODO: how to use?
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "EdenEast/nightfox.nvim"
  },
  {
    "lervag/vimtex"
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').set_default_keymaps()
    end

  },
  {
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
        "--folding-ranges",
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
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        default_mappings = true,
        dismiss_on_move = true,
        focus_on_open = false
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {}
      vim.cmd [[hi TreesitterContextBottom gui=underline guisp=Grey]]
    end
  },
  {
    "mechatroner/rainbow_csv"
  },
  -- {
  --   -- cargo install --locked code-minimap
  --   "wfxr/minimap.vim",
  --   config = function()
  --     -- TODO: minimap auto session problem
  --     vim.g.minimap_auto_start = 1
  --   end,
  -- },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({
        hide_cursor = false,
        easing_function = "sine",
        perfomance_mode = true,
        -- TODO: decrease time scale
      })

      local t    = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '50' } }
      t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '50' } }
      t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '150' } }
      t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '150' } }
      t['<C-y>'] = { 'scroll', { '-0.10', 'false', '10' } }
      t['<C-e>'] = { 'scroll', { '0.10', 'false', '10' } }
      t['zt']    = { 'zt', { '50' } }
      t['zz']    = { 'zz', { '50' } }
      t['zb']    = { 'zb', { '50' } }

      require('neoscroll.config').set_mappings(t)
    end
  },
  {
    -- TODO config: https://github.com/folke/noice.nvim
    -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        -- enable macro recording
        -- TODO: nvim-tree + mason still show pop-ups
        routes = {
          {
            view = "mini",
            filter = { event = "msg_showmode" },
          },
        },
        -- clean cmdline_popup
        views = {
          cmdline_popup = {
            border = {
              style = "none",
              padding = { 1, 1 },
            },
            filter_options = {},
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        },


        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },

        messages = {
          view = "mini",
          view_error = "mini",
          view_warn = "mini",
        },

        presets = {
          bottom_search = false,        -- use a classic bottom cmdline for search
          command_palette = false,      -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end
  },
  {
    "microsoft/python-type-stubs",
    cond = false
    -- https://github.com/microsoft/pyright/issues/4878
    -- TODO: "stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs""
  },
  {
    "christoomey/vim-tmux-navigator"
  },
  {
    'andymass/vim-matchup'
  }
}
