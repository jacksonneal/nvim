local table = require("util.table")
local colorscheme = require("plugins.colorscheme")
local tree_explorer = require("plugins.tree-explorer")

local M = {}

local plugins = table.cat(
  colorscheme.configs,
  tree_explorer.configs
)

M.setup = function()
    local lazy = require("lazy")
    lazy.setup(plugins)
end

return M
