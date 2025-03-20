-- Module for config settings

local iter = require("core.iter")

local SETTINGS_FILE_NAME = "nvim.json"
local GLOBAL_SETTINGS_FILEPATH = "~/.config/nvim" .. "/" .. SETTINGS_FILE_NAME
local PROJECT_SETTINGS_FILEPATH = vim.fn.getcwd() .. "/" .. SETTINGS_FILE_NAME

---Config settings module
---@class Config
---@field initialized boolean
---@field settings Settings
---@field setup fun(self): nil

---Config settings
---@class Settings
---@field colorscheme Colorscheme
---@field denols LspSettings
---@field eslint LspSettings
---@field pyright PyrightSettings
---@field tailwindcss LspSettings
---@field tsserver LspSettings
---@field volar LspSettings

---Colorschemes
---@alias Colorscheme
---| '"gruvbox-material"
---| '"rose-pine-dawn"'

---LSP settings
---@class LspSettings
---@field disable boolean

---Pyright settings
---@class PyrightSettings
---@field pythonPath string | nil

---@type Config
return {
  initialized = false,
  settings = {
    colorscheme = "rose-pine-dawn",
    denols = {
      disable = true,
    },
    eslint = {
      disable = false,
    },
    pyright = {
      pythonPath = nil,
    },
    tailwindcss = {
      disable = false,
    },
    tsserver = {
      disable = false,
    },
    volar = {
      disable = true,
    },
  },
  setup = function(self)
    local setting_override_paths =
      { GLOBAL_SETTINGS_FILEPATH, PROJECT_SETTINGS_FILEPATH }
    for setting_override_path in iter.list_iter(setting_override_paths) do
      if vim.fn.filereadable(setting_override_path) == 0 then
        goto continue
      end

      local settings =
        vim.fn.json_decode(vim.fn.readfile(setting_override_path))
      self.settings = vim.tbl_deep_extend("force", self.settings, settings)

      ::continue::
    end

    self.initialized = true
  end,
}
