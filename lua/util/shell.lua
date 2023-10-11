local fn = vim.fn

local M = {}

M.call = function(args)
	local output = fn.system(args)
	assert(vim.v.shell_error == 0, "Shell call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
end

return M
