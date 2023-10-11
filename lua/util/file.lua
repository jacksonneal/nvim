local json = vim.json
local uv = vim.loop

local M = {}

M.is_dir = function(filepath)
  local stat = uv.fs_stat(filepath)
  return stat and stat.type == "directory" or false
end

M.is_file = function(filepath)
  local stat = uv.fs_stat(filepath)
  return stat and stat.type == "file" or false
end

M.read = function(filepath)
  local fd = assert(uv.fs_open(filepath, "r", 438))
  local stat = assert(uv.fs_fstat(fd))
  local data = assert(uv.fs_read(fd, stat.size, 0))
  assert(uv.fs_close(fd))
  return data
end

M.read_json = function(filepath)
  return json.decode(M.read(filepath))
end

return M
