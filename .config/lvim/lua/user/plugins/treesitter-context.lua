return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {}
      vim.cmd [[hi TreesitterContextBottom gui=underline guisp=Grey]]
    end
  }
}
