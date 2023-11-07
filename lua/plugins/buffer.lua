-- Module for buffer management plugins.

local mini_bufremove_config = function()
  local mini_bufremove = require("mini.bufremove")
  mini_bufremove.setup()

  vim.api.nvim_create_user_command("MiniBufremove", function()
    mini_bufremove.delete(0, false)
  end, {})
end

local plugins = {
  {
    -- buffer removal
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        "<cmd>MiniBufremove<cr>",
        desc = "Delete current buffer",
      },
    },
    config = mini_bufremove_config,
  },
  {
    -- buffer line
    "akinsho/bufferline.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = {
      "nvim-web-devicons",
    },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle buffer pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete unpinned buffers" },
    },
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },
}

return plugins
