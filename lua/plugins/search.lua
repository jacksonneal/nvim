-- Module for search plugins.

local plugins = {
  {
    -- search
    "echasnovski/mini.pick",
    lazy = false,
    keys = {
      { "<leader><leader>", "<cmd>Pick files tool='git'<cr>", desc = "Search files" },
      { "<leader>/", "<cmd>Pick grep<cr>", desc = "Search global" },
      { "<leader>R", "<cmd>Pick resume<cr>", desc = "Resume search" },
    },
    opts = {
      mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
      },
    },
  },
  {
    -- extra mini pickers
    "echasnovski/mini.extra",
    lazy = false,
    keys = {
      { "<leader>s", "<cmd>Pick lsp scope='document_symbol'<cr>", desc = "Search symbols" },
      { "<leader>r", "<cmd>Pick lsp scope='references'<cr>", desc = "Search references" },
    },
    config = true,
  },
}

return plugins
