-- # Tmux hide status bar
-- # TODO: not great if other panes are open
-- vim.cmd [[autocmd VimEnter,VimLeave * silent !tmux set status]]

-- vim option
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

--# split with (h)orizontal
vim.cmd [[nnoremap <C-W>h :split<CR>]]

-- TODO:
-- -- code folding
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldmethod = "expr"
-- unfold all on open
-- vim.cmd("autocmd BufWinEnter,FileReadPost,BufRead * silent! :normal! zR")

-- lvim.builtin.which_key.mappings["f"] = {
--   name = "Fold",
--   o = { "<cmd>:foldopen<CR>", "Open" },
--   c = { "<cmd>:foldclose<CR>", "Close" },
-- }

-- spelling
-- TODO: activate + set hotkeys
vim.opt.spell = false
vim.opt.spelllang = { "en", "de" }


-- TODO spelling shortcuts
lvim.builtin.which_key.mappings["z"] = {
  name = "Zpelling :)",
  t = { "<cmd>:set spell!<cr>", "Toggle spelling" },
  -- g = { "<cmd>:set spell!<cr>", "Add word as good word" },
  -- b = { "<cmd>:set spell!<cr>", "Add word as bad word" },
  -- u = { "<cmd>:set spell!<cr>", "Undo add word to list" },
  -- l = { "<cmd>:set spell!<cr>", "List word suggestions" },
}

-- disable comment next line
-- https://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
vim.cmd [[autocmd BufNewFile,BufRead,BufEnter * setlocal formatoptions-=cro]]

-- overwrite because it was broken :/
-- lvim.keys.normal_mode["gd"] = vim.lsp.buf.definition()

-- general
lvim.builtin.dap.active = true
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}

-- LSP
-- lvim.builtin.treesitter.ensure_installed = "all"
-- lvim.builtin.treesitter.ignore_install = "csv"

-- TODO add config files for all languages with dap + LSP
-- python
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pylyzer" })
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } },
}

-- dap
local dap = require('dap')

dap.adapters.python = {
  type = 'executable',
  command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    name = 'Launch File',
    type = 'python',
    request = 'launch',
    program = '${file}',
    cwd = '${workspaceFolder}',
    console = "integratedTerminal",
    stopOnEntry = false,
    args = {},
    pythonPath = function()
      return 'python3'
    end,
  },
}


dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode-14',
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
-- dap.adapters.clangd = {
--   id = 'clangd',
--   type = 'executable',
--   command = 'clangd',
-- }

-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "clangd",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--   },
-- }
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- dap.adapters.codelldb = {
--   type = 'server',
--   port = "${port}",
--   executable = {
--       -- CHANGE THIS to your path!
--       command = '/absolute/path/to/codelldb/extension/adapter/codelldb',
--       args = {"--port", "${port}"},

--       -- On windows you may have to uncomment this:
--       -- detached = false,
--     }
-- }

dap.adapters.haskell = {
  type = 'executable',
  command = 'haskell-debug-adapter',
  args = { '--hackage-version=0.0.33.0' },
}

dap.configurations.haskell = {
  {
    type = 'haskell',
    request = 'launch',
    name = 'Debug',
    workspace = '${workspaceFolder}',
    startup = "${file}",
    stopOnEntry = true,
    logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
    logLevel = 'WARNING',
    ghciEnv = vim.empty_dict(),
    ghciPrompt = "λ: ",
    -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
    ghciInitialPrompt = "λ: ",
    ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
  },
}

dap.adapters.netcoredbg = {
  type = 'executable',
  command = 'netcoredbg',
  args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
  {
    type = 'netcoredbg',
    name = 'Launch',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"




lvim.builtin.nvimtree.setup.update_cwd = false
lvim.builtin.nvimtree.setup.update_focused_file.update_root = false
-- dont open root directory
lvim.builtin.project.manual_mode = true

-- -- Change theme settings
-- lvim.colorscheme = "carbonfox"
local dashboardHeader = {
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠴⠒⠒⠲⠤⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠋⠀⠀⠀⠀⠠⢚⣂⡀⠈⠲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⡴⠆⠀⠀⠀⠀⠀⢎⠐⢟⡇⠀⠈⢣⣠⠞⠉⠉⠑⢄⠀⠀⣰⠋⡯⠗⣚⣉⣓⡄]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢠⢞⠉⡆⠀⠀⠀⠀⠀⠓⠋⠀⠀⠀⠀⢿⠀⠀⠀⠀⠈⢧⠀⢹⣠⠕⠘⢧⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠘⠮⠔⠁⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠈⣇⠀⢳⠀⠀⠘⡆⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠋⠉⠓⠦⣧⠀⠀⠀⠀⢦⠤⠤⠖⠋⠇⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠸⡄⠈⡇⠀⠀⢹⡀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠙⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠈⣆⠀⠀⠀⢱⠀⡇⠀⠀⠀⡇⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠀⠀⠀⠀⠀⠀⠘⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠸⡄⠀⠀⠀⠳⠃⠀⠀⠀⡇⠀]],
  [[⠀⠀⠀⠀⠀⢠⢏⠉⢳⡀⠀⠀⢹⠀⠀⠀⠀⢠⠀⠀⠀⠑⠤⣄⣀⡀⠀⠀⠀⠀⠀⣀⡤⠚⠀⠀⠀⠀⠀⢸⢢⡀⠀⠀⠀⠀⠀⢰⠁⠀]],
  [[⠀⠀⣀⣤⡞⠓⠉⠁⠀⢳⠀⠀⢸⠀⠀⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⢸⠀⠙⠦⣤⣀⣀⡤⠃⠀⠀]],
  [[⠀⣰⠗⠒⣚⠀⢀⡤⠚⠉⢳⠀⠈⡇⠀⠀⠀⢸⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠸⠵⡾⠋⠉⠉⡏⠀⠀⠀⠈⠣⣀⣳⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠳⡄⠀⠀⠀⠀⠀⠀⠀⡰⠁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠲⠤⠤⠤⠴⠚⠁⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
}

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.alpha.dashboard.section.header.val = dashboardHeader
lvim.builtin.alpha.dashboard.section.footer.val = "Simplicity, carried to the extreme, becomes elegance."


lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true
lvim.builtin.nvimtree.setup.view.width = 70

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
    -- TODO: ignore nvvim tree + map
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = nil,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = nil,
        auto_session_use_git_branch = nil,

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
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
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

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})
