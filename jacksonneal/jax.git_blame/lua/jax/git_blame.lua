-- Enables virtual text git blame on your current cursor line.

local M = {}

function M.git_blame(bufnr)
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  print(buf_name)
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  print(line)
  local blame = vim.fn.system({
    "git",
    "blame",
    buf_name,
    "-L",
    line .. "," .. line,
  })
  print(blame)
end

M.git_blame(0)

return M
