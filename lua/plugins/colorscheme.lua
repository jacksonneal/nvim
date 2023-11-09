-- Module for colorscheme plugins.

local settings = require("core.config").settings

local function set_colorscheme()
  vim.cmd.colorscheme(settings.colorscheme)
end

local function gruvbox_material_config()
  vim.g.gruvbox_material_better_performance = 1

  vim.g.gruvbox_material_disable_italic_comment = 1
  vim.g.gruvbox_material_enable_italic = 0
  vim.g.gruvbox_material_enable_bold = 0

  vim.g.gruvbox_material_foreground = "mix"
  vim.g.gruvbox_material_background = "hard"
  vim.g.gruvbox_material_ui_contrast = "high"
  vim.g.gruvbox_material_float_style = "dim"

  set_colorscheme()
end

local plugins = {
  {
    -- gruvbox with softened palette
    "sainnhe/gruvbox-material",
    enabled = settings.colorscheme == "gruvbox-material",
    lazy = false,
    priority = 1000,
    config = gruvbox_material_config,
  },
  {
    -- nord vim
    "nordtheme/vim",
    enabled = settings.colorscheme == "nord",
    lazy = false,
    priority = 1000,
    config = set_colorscheme,
  },
}

return plugins
