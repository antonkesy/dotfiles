vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- disable comment jump to next line
-- https://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
vim.cmd([[autocmd BufNewFile,BufRead,BufEnter * setlocal formatoptions-=cro]])

-- general
lvim.log.level = "info"

-- key mappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
--# split with (h)orizontal
lvim.keys.normal_mode["<C-W>h"] = ":split<CR>"

-- don't open root directory
lvim.builtin.project.manual_mode = true
-- keep active for lazygit
lvim.builtin.terminal.active = true

lvim.builtin.which_key.mappings["v"] = {
  name = "Visual",
  b = { "<cmd>:set wrap!<cr>", "Toggle text wrap" },
}

vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- Trigger `autoread` when files change on disk
vim.cmd([[set autoread]])
vim.cmd([[autocmd FocusGained * silent! checktime]])

-- Fuzzy find in current buffer
lvim.builtin.which_key.mappings["sT"] = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find in current buffer" }
lvim.builtin.which_key.mappings["sF"] = { "<cmd>Telescope buffers<CR>", "Find files in open buffers" }

-- Add keybinding for :MakeitOpen
lvim.builtin.which_key.mappings["m"] = { ":MakeitOpen<CR>", "MakeitOpen" }

-- nvim-tree
lvim.builtin.nvimtree.setup.view.number = true


-- window picker workaround to avoid conflict with save file
lvim.builtin.which_key.mappings["w"] = {
  function()
    local picked_window_id = require('window-picker').pick_window({
      hint = 'floating-big-letter'
    })
    if picked_window_id then
      vim.api.nvim_set_current_win(picked_window_id)
    end
  end,
  "Pick a window"
}
