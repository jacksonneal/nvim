local autocommands = require("core.autocommands")
local format = require("core.format")
local keymaps = require("core.keymaps")
local lazy = require("core.lazy")
local options = require("core.options")
local settings = require("core.settings")

local plugins = require("plugins")

local cmd = vim.cmd

local M = {}

M.setup = function()
  settings.setup()
  local config = settings.config

  options.setup()
  keymaps.setup()
  autocommands.setup()

  format.setup()

  lazy.bootstrap()
  plugins.setup()

  cmd.colorscheme(config.colorscheme)

  require("lspconfig").lua_ls.setup({
    settings = {
      Lua = {
        runtime = {
          version = {
            "LuaJIT",
          },
        },
        diagnostics = {
          globals = {
            "vim",
          },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
      },
    },
    on_attach = function(_client, bufnr)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

      vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = bufnr })
      vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = bufnr })

      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.implementation, { buffer = bufnr })
    end,
  })
end

return M
