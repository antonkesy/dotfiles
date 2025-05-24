return {
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        default_mappings = true,
        dismiss_on_move = true,
        focus_on_open = false
      }
    end
  }
}
