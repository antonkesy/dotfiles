return {
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
  }
}
