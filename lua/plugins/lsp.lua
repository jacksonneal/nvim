local M = {}

M.configs = {
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls" },
    },
  },
  "neovim/nvim-lspconfig",
}

return M
