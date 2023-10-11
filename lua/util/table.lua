local M = {}

M.cat = function(t, ...)
  local new = {unpack(t)}
  for i, v in ipairs({...}) do
      for ii, vv in ipairs(v) do
          new[#new+1] = vv
      end
  end
  return new
end


M.merge = function(...)
  return vim.tbl_deep_extend(
    'force',
    {},
    ...
  )
end

return M
