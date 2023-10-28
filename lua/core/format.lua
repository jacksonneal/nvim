local buffer = require("util.buffer")
local shell = require("util.shell")

local api = vim.api

local function format_lua()
  local filepath = buffer.filepath()
  shell.call({ "stylua", filepath })
end

local function format()
  api.nvim_command("w")

  local file_type = buffer.file_type()
  if file_type == "lua" then
    format_lua()
  else
    vim.notify("No formatter available for " .. file_type)
  end

  api.nvim_command("edit!")
end

vim.keymap.set("n", "<leader>f", format)
