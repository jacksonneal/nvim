-- File is loaded by init.lua
-- Loads all config modules

require("config.lazy")

-- Module object
--
---@type StardogConfig
local M = {}

-- Required lazy.nvim version
--
---@type string
M.lazy_version = ">=9.1.0"

-- Default module config
--
---@class StardogConfig
local defaults = {
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
}

-- Options.
--
---@type StardogConfig
local options

-- Setup the config module.
--
---@param opts? StardogConfig - overrides
function M.setup(opts)
  -- initialize
  if not M.did_init then
    M.init()
  end

  -- combine passed opts with defaults to form options
  options = vim.tbl_deep_extend("force", defaults, opts or {})
  --- ensure lazy.nvim version
  if not M.has_lazy() then
    require("lazy.core.util").error(
      "**Stardog** needs **lazy.nvim** version "
        .. M.lazy_version
        .. " to work properly.\n"
        .. "Please upgrade **lazy.nvim**",
      { title = "Stardog" }
    )
    error("Exiting")
  end

  if vim.fn.argc(-1) == 0 then
    -- no files in global argument list, wait to load
    local augroup = require("config.util").augroup
    vim.api.nvim_create_autocmd("User", {
      group = augroup("config"),
      pattern = "VeryLazy",
      callback = function()
        M.load("autocmds")
        M.load("keymaps")
      end,
    })
  else
    -- load now to affect opened buffers
    M.load("autocmds")
    M.load("keymaps")
  end
end

-- Check that a compatible version of lazy.nvim is installed
--
---@param range? string
---@return boolean - whether valid version is installed
function M.has_lazy(range)
  local Semver = require("lazy.manage.semver")
  return Semver.range(range or M.lazy_version)
    :matches(require("lazy.core.config").version or "0.0.0")
end

-- Load config modules
--
---@param name "autocmds" | "keymaps" | "options"
function M.load(name)
  local Util = require("lazy.core.util")
  local function _load(mod)
    require(mod)
    Util.try(function() end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local info = require("lazy.core.cache").find(mod)
        if info == nil or (type(info) == "table" and #info == 0) then
          return
        end
        Util.error(msg)
      end,
    })
  end
  _load("config." .. name)
  -- Load autocmds for config
  local pattern = "Stardog" .. name:sub(2, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
-- Initialize module
function M.init()
  if not M.did_init then
    M.did_init = true
    -- lazy initialize notifications
    require("config.util").lazy_notify()

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    require("config").load("options")
  end
end

-- setup module metatable
setmetatable(M, {
  -- index into defaults or options if configured
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options StardogConfig
    return options[key]
  end,
})
return M
