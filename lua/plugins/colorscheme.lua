-- Colorscheme plugins.

local settings = require("core.config").settings

-- Configure gruvbox-material colorscheme.
local function config_gruvbox_material()
  vim.g.gruvbox_material_background = "hard"
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_disable_italic_comment = 1
  vim.g.gruvbox_material_float_style = "dim"
  vim.g.gruvbox_material_foreground = "mix"
  vim.g.gruvbox_material_ui_contrast = "high"
end

return {
  {
    -- gruvbox with softened palette
    "sainnhe/gruvbox-material",
    enabled = settings.colorscheme == "gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      config_gruvbox_material()
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    -- natural pine, faux fur, soho vibe
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = settings.colorscheme == "rose-pine-dawn",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("rose-pine-dawn")
    end,
  }
}
