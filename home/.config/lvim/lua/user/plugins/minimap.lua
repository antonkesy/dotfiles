return {
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    init = function()
      vim.g.minimap_auto_start = 0
      vim.g.minimap_auto_start_win_enter = 0
      vim.g.minimap_highlight_search = 1
      vim.g.minimap_width = 20

      lvim.builtin.which_key.mappings["v"].m = {
        "[[:MinimapToggle<CR>]]", "Toggle MiniMap",
      }
    end,
  }
}
