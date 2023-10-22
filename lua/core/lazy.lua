local const = require("const")
local settings = require("core.settings")
local file = require("util.file")
local shell = require("util.shell")

local opt = vim.opt

local M = {}

function M.bootstrap()
  if not file.is_dir(const.LAZY_PATH) then
    shell.call(const.LAZY_CLONE_CMD)
  end
  opt.rtp:prepend(const.LAZY_PATH)
end

M.setup = function()
  local config = settings.config
  require("lazy").setup({})
end

return M
