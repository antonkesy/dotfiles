return {
  {
    dir = "/home/ak/workspace/rephrasinator.nvim",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    init = function()
      require("rephrasinator").setup()
    end,
  }
}
