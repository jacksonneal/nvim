local buffer = require("util.buffer")
local shell = require("util.shell")

local api = vim.api

local M = {}

local function format_lua()
  local filepath = buffer.filepath()
  shell.call({ "stylua", filepath })
end

local function format()
  api.nvim_command("w")

  local file_type = buffer.file_type()
  if file_type == "lua" then
    format_lua()
  end

  api.nvim_command("edit!")
end

M.setup = function()
  vim.keymap.set("n", "<leader>f", format)
end

return M
