return {
  {
    "stevearc/overseer.nvim",
    opts = {},
    config = function()
      require('overseer').setup()
      -- TODO: add more configs
      -- https://github.com/stevearc/overseer.nvim/blob/master/doc/guides.md#actions
      lvim.builtin.which_key.mappings["o"] = {
        name = "Overseer",
        t = { "<cmd>OverseerToggle<cr>", "Toggle Overseer" },
        r = { "<cmd>OverseerRun<cr>", "Run Overseer" },
      }
    end

  }
}
