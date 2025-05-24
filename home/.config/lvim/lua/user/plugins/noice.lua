return { -- TODO: issue with lualine -> buffer selection get overwritten
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- Disabled notify because its to intrusive in my opinion
      -- "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        -- enable macro recording
        routes = {
          {
            view = "mini",
            filter = { event = "msg_showmode" },
          },
        },
        -- clean cmdline_popup
        views = {
          cmdline_popup = {
            border = {
              style = "none",
              padding = { 1, 1 },
            },
            filter_options = {},
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        },


        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },

        messages = {
          view = "mini",
          view_error = "mini",
          view_warn = "mini",
        },

        presets = {
          bottom_search = false,
          command_palette = false,      -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true,            -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
      })
    end
  }
}
