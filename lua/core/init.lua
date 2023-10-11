local format = require("core.format")
local lazy = require("core.lazy")
local options = require("core.options")
local plugins = require("plugins")
local settings = require("core.settings")

local cmd = vim.cmd

local M = {}

M.setup = function()
  settings.setup()
  local config = settings.config

  options.setup(config)
  format.setup()

  lazy.bootstrap()

  plugins.setup()

  cmd.colorscheme(config.colorscheme)
end

return M
