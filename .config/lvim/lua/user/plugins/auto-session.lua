return {
  {
    -- TODO: ignore nvim tree + map
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = nil,
        auto_session_use_git_branch = nil,

      }

      -- workaround nvim tree empty buffer after session restore and minimap
      local function restore_nvim_tree()
        require("nvim-tree.api").tree.open({ focus = false })
        require("nvim-tree.api").tree.close()
        vim.cmd("Minimap")
      end

      local function close_minimap()
        vim.cmd("MinimapClose")
      end

      require('auto-session').setup {
        pre_save_cmds = { close_minimap },
        post_restore_cmds = { restore_nvim_tree }
      }
    end,
  }
}
