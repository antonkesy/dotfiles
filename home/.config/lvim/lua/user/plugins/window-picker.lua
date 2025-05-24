return {
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup(
        {
          filter_rules = {
            autoselect_one = false,
            include_current_win = true,
          },
        })
      -- -- remove LEADER + w
      -- -- lvim.builtin.which_key.mappings["w"] = nil
      -- -- Key mapping for window picker
      -- lvim.builtin.which_key.mappings["w"] = {
      --   function()
      --     local picked_window_id = require('window-picker').pick_window({
      --       hint = 'floating-big-letter'
      --     })
      --     if picked_window_id then
      --       vim.api.nvim_set_current_win(picked_window_id)
      --     end
      --   end,
      --   "Pick a window"
      -- }
    end,
  }
}
