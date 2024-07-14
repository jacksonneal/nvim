-- Module for iterators.

local M = {}

---Create a list iterator over values only.
--
---@generic T: table, K, V
---@param t T - to create iterator for
---@return fun(): V - iterator
function M.list_iter(t)
  local i = 0
  local n = #t
  return function()
    i = i + 1
    if i <= n then
      return t[i]
    end
  end
end

return M
