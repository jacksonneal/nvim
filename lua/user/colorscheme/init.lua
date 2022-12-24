require("user.colorscheme.rose-pine")
require("user.colorscheme.tokyonight")

local colorscheme = "rose-pine"

pcall(vim.cmd, "colorscheme " .. colorscheme)
