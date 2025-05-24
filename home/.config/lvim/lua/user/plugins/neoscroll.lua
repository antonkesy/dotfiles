return {
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({
        hide_cursor = false,
        easing_function = "sine",
        perfomance_mode = true,
      })

      neoscroll = require('neoscroll')
      local keymap = {
        ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 50 }) end,
        ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 50 }) end,
        ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 150 }) end,
        ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 150 }) end,
        ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 10 }) end,
        ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 10 }) end,
        ["zt"]    = function() neoscroll.zt({ half_win_duration = 50 }) end,
        ["zz"]    = function() neoscroll.zz({ half_win_duration = 50 }) end,
        ["zb"]    = function() neoscroll.zb({ half_win_duration = 50 }) end,
      }
      local modes = { 'n', 'v', 'x' }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end
  }
}
