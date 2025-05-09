-- Module for config settings.

---Config settings module.
---@class ConfigSettingsModule
---@field settings ConfigSettings

---Config settings.
---@class ConfigSettings
---@field colorscheme Colorscheme
---@field denols LspSettings
---@field eslint LspSettings
---@field pyright PyrightSettings
---@field tailwindcss LspSettings
---@field tsserver LspSettings
---@field volar LspSettings

---Colorscheme.
---@alias Colorscheme
---| '"rose-pine-dawn"'

---LSP settings.
---@class LspSettings
---@field disable boolean

---Pyright settings
---@class PyrightSettings
---@field pythonPath string | nil

---@type ConfigSettings
local defaults = {
  colorscheme = "rose-pine-dawn",
  denols = {
    disable = false,
  },
  eslint = {
    disable = false,
  },
  pyright = {
    pythonPath = nil,
  },
  tailwindcss = {
    disable = true,
  },
  tsserver = {
    disable = true,
  },
  volar = {
    disable = true,
  },
}

require("neoconf.plugins").register({
  name = "config-settings",
  on_schema = function(schema)
    schema:import("config-settings", defaults)
  end,
})

---@type ConfigSettingsModule
return {
  settings = require("neoconf").get("config-settings", defaults)
}
