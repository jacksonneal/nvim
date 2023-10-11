local M = {}

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "L", api.tree.expand_all, opts("Expand all"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
  vim.keymap.set("n", "H", api.tree.collapse_all, opts("Close all"))

  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open v-split"))
end

M.keys = {
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", "Toggle tree" },
  { "<C-e>", "<cmd>NvimTreeFocus<cr>", "Focus tree" },
}

M.opts = {
  on_attach = on_attach
}

return M
