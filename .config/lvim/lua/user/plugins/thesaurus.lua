return {
  {
    "Ron89/thesaurus_query.vim",
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>ts', [[:ThesaurusQueryReplaceCurrentWord<CR>]],
        { noremap = true, silent = true })
    end,
  }
}
