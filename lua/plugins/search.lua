-- Search plugins.

local plugins = {
  {
    -- search
    "echasnovski/mini.pick",
    lazy = false,
    keys = {
      { "<leader><leader>", "<cmd>Pick files tool='rg'<cr>", desc = "Search files" },
      { "<leader>/", "<cmd>Pick grep tool='rg'<cr>", desc = "Search global" },
      { "<leader>R", "<cmd>Pick resume<cr>", desc = "Resume search" },
    },
    opts = {
      mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
      },
    },
    config = function(_, opts)
      require("mini.pick").setup(opts)
      vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "Normal" })
    end,
  },
  {
    -- extra pickers
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
