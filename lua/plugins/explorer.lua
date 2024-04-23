-- Module for file explorer plugins.

local function nvim_tree_opts()
  local function on_attach(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr, desc = "Open node" })
    vim.keymap.set("n", "v", api.node.open.vertical, { buffer = bufnr, desc = "Open v-split" })
    vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr, desc = "Collapse" })
  end

  return {
    on_attach = on_attach,
    filters = {
      -- do not show
      custom = { "^.git$" },
      -- exclude from filters (always show)
      exclude = { "^.env*" }
    }
  }
end

local plugins = {
  {
    -- file explorer
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      -- file type icons and colors
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFocus",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", "Toggle tree" },
      { "<leader>E", "<cmd>NvimTreeFocus<cr>",  "Focus tree" },
    },
    opts = nvim_tree_opts,
  },
}

return plugins
