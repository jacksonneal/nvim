-- Module for buffer management plugins.

local function delete_cur_buf()
  require("mini.bufremove").delete(0, false)
end

local function mini_bufremove_init()
  vim.api.nvim_create_user_command("MiniBufremove", delete_cur_buf, {})
end

local plugins = {
  {
    -- buffer removal
    "echasnovski/mini.bufremove",
    keys = {
      { "<leader>bd", delete_cur_buf, desc = "Delete current buffer" },
    },
    config = true,
    init = mini_bufremove_init,
  },
  {
    -- buffer line
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-web-devicons",
    },
    event = {
      "BufReadPre",
      "BufNewFile",
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
