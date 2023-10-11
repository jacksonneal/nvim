local const = require("const")
local file = require("util.file")
local table = require("util.table")

local M = {}

local function load_settings()
  if not file.is_file(const.SETTINGS_FILEPATH) then
    return {}
  end
  return file.read_json(const.SETTINGS_FILEPATH)
end

M.setup = function()
  M.config = table.merge(const.DEFAULT_SETTINGS, load_settings())
end

return M
