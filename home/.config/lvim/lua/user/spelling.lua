vim.opt.spell = false
vim.opt.spelllang = { "en" }

-- vim.cmd([[hi clear SpellBad]])
-- vim.cmd([[hi SpellBad ctermfg=red guifg=red]])
-- workaround for spelling highlighting not set
vim.api.nvim_exec([[
  augroup MySpellBadHighlight
    autocmd!
    autocmd ColorScheme * hi SpellBad ctermfg=red guifg=red
  augroup END
]], false)

lvim.builtin.which_key.mappings["z"] = {
  name = "Zpelling :)",
  t = { "<cmd>:set spell!<cr>", "Toggle spelling" },
  e = { "<cmd>:setlocal spelllang=en<CR><cr>", "Enable English spelling" },
  g = { "<cmd>:setlocal spelllang=de<CR><cr>", "Enable German spelling" },
  -- g = { "<cmd>:set spell!<cr>", "Add word as good word" },
  -- b = { "<cmd>:set spell!<cr>", "Add word as bad word" },
  -- u = { "<cmd>:set spell!<cr>", "Undo add word to list" },
  -- l = { "<cmd>:set spell!<cr>", "List word suggestions" },
}
