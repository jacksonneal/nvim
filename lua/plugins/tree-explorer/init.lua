nvim_tree = require("plugins.tree-explorer.nvim-tree")

local M = {}

M.configs = {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = nvim_tree.keys,
    opts = nvim_tree.opts,
  },
  "nvim-tree/nvim-web-devicons",
}

return M
