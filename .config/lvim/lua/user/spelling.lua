-- spelling
-- TODO: activate + set hotkeys
vim.opt.spell = true
vim.opt.spelllang = { "en" }
-- vim.opt.spelllang = { "en", "de" }

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
  -- g = { "<cmd>:set spell!<cr>", "Add word as good word" },
  -- b = { "<cmd>:set spell!<cr>", "Add word as bad word" },
  -- u = { "<cmd>:set spell!<cr>", "Undo add word to list" },
  -- l = { "<cmd>:set spell!<cr>", "List word suggestions" },
}
