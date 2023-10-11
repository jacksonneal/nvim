local api = vim.api

local M = {}

M.filepath = function()
  return api.nvim_buf_get_name(0)
end

M.file_type = function()
  return api.nvim_buf_get_option(0, "filetype")
end

M.text = function()
  local text = table.concat(api.nvim_buf_get_lines(0, 0, -1, true), "\n")
  if api.nvim_buf_get_option(0, "eol") then
    text = text .. "\n"
  end
  return text
end

return M
