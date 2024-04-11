-- Enables virtual text diagnostics on your current cursor line.

local M = {}

-- Make iterator over the values of the given table.
--
---@generic V - table value type
---@param t table<_, V> - to iterate over values of
---@return function - fun(): V, iterator producing values
local function values(t)
  local i = 0
  return function()
    i = i + 1
    return t[i]
  end
end

-- Access the cursor line diagnostics of the given buffer and current window.
--
---@param bufnr integer - to access diagnostics for
---@return Diagnostic[] - list of diagnostic entries
local function cur_ln_dx(bufnr)
  return vim.diagnostic.get(bufnr, { ["lnum"] = vim.api.nvim_win_get_cursor(0)[1] - 1 })
end

-- Select the most severe diagnostic from the given list.
--
---@param dx Diagnostic[] - to select most sever from
---@return Diagnostic | nil - most severe diagnostic
local function most_severe_dx(dx)
  local ms_dx = nil
  for cur_dx in values(dx) do
    if ms_dx == nil or ms_dx.severity < cur_dx.severity then
      ms_dx = cur_dx
    end
  end
  return ms_dx
end

-- Namespace for current line diagnostic virtual text.
M.ns = vim.api.nvim_create_namespace("cur_ln_dx_virtual_text")

-- Hide current line diagnostic virtual text of the given buffer.
--
---@param bufnr integer - to hide diagnostics for
function M.hide(bufnr)
  vim.diagnostic.handlers.virtual_text.hide(M.ns, bufnr)
end

-- Show current line diagnostic virtual text.
--
---@param bufnr integer - to show diagnostics for
function M.show(bufnr)
  local diagnostic = most_severe_dx(cur_ln_dx(bufnr))
  vim.diagnostic.handlers.virtual_text.show(M.ns, bufnr, { diagnostic })
end

-- Autocommand group for current line diagnostics virtual text.
M.augroup = vim.api.nvim_create_augroup("cur_ln_dx_virtual_text", {
  clear = true,
})

-- Whether current line diagnostic virtual text is enabled.
M.is_enabled = false

-- Configure autocommands for current line diagnostics virtual text
-- for the given buffer.
--
---@param bufnr integer - to configure autocommands for
function M.on_attach_dx(bufnr)
  -- clear preexisting autocommands
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = "cur_ln_dx_virtual_text",
  })

  -- show when cursor stagnates
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "cur_ln_dx_virtual_text",
    buffer = bufnr,
    callback = function()
      -- remove preexisting virtual text
      M.hide(bufnr)
      if M.is_enabled then
        M.show(bufnr)
      end
    end,
  })
end

---@class CurLnDxOpts
---@field is_enabled boolean | nil

-- Plugin entrypoint.
--
---@param opts CurLnDxOpts - to configure
function M.setup(opts)
  M.is_enabled = opts.is_enabled or false
  -- create user command to toggle current line diagnostics virtual text
  vim.api.nvim_create_user_command("CurLnDxToggle", function()
    M.is_enabled = not M.is_enabled
  end, {})
end

return M
