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

  require("lspconfig").lua_ls.setup({})
end

return M
