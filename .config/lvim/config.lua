-- vim option
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

--# split with (h)orizontal
vim.cmd [[nnoremap <C-W>h :split<CR>]]

-- disable comment next line
-- https://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
vim.cmd [[autocmd BufNewFile,BufRead,BufEnter * setlocal formatoptions-=cro]]

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}

-- key mappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- don't open root directory
lvim.builtin.project.manual_mode = true

-- keep active for lazygit
lvim.builtin.terminal.active = true

require("user.colorscheme")
require("user.dap")
require("user.fold")
require("user.formatter")
require("user.plugins")
require("user.spelling")
require("user.tree-sitter")
require("user.lsp")
