local table = require("util.table")

local colorscheme = require("plugins.colorscheme")
local completion = require("plugins.completion")
local lsp = require("plugins.lsp")
local tree_explorer = require("plugins.tree-explorer")

local M = {}

M.setup = function()
  local lazy = require("lazy")
  lazy.setup({
    colorscheme.configs,
    tree_explorer.configs,
    lsp.configs,
    completion.configs,
    { "neovim/nvim-lspconfig"},
    { "folke/neodev.nvim", opts = {} },
  })

  -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
  require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
  })

  -- then setup your lsp server as usual
  local lspconfig = require("lspconfig")

  -- example to setup lua_ls and enable call snippets
  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  })
end

return M
