---@module 'modules.config'
---Configuration settings module for managing LSP server enable/disable state.
---
---This module uses neoconf to manage configuration settings that can be overridden
---per-project using .neoconf.json files.
---
---@see https://github.com/folke/neoconf.nvim

---Config settings module.
---@class ConfigModule
---@field settings ConfigSettings

---Config settings.
---@class ConfigSettings
---@field denols LspSettings
---@field eslint LspSettings
---@field jsonls LspSettings
---@field lua_ls LspSettings
---@field pyright LspSettings
---@field ruff LspSettings
---@field tailwindcss LspSettings
---@field ts_ls LspSettings

---LSP settings.
---@class LspSettings
---@field enable boolean

---@type ConfigSettings
local defaults = {
  denols = {
    enable = false,
  },
  eslint = {
    enable = true,
  },
  jsonls = {
    enable = true,
  },
  lua_ls = {
    enable = true,
  },
  pyright = {
    enable = true,
  },
  ruff = {
    enable = true,
  },
  tailwindcss = {
    enable = true,
  },
  ts_ls = {
    enable = true,
  },
}

require("neoconf.plugins").register({
  name = "lsp-settings",
  on_schema = function(schema)
    schema:import("lsp-settings", defaults)
  end,
})

---@type ConfigModule
return {
  settings = require("neoconf").get("lsp-settings", defaults),
}
