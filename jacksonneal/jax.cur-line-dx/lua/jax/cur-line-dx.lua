-- Current line diagnostics.

local M = {}

-- Access the current line diagnostics.
local function current_line_diagnostics()
  return vim.diagnostic.get(0, { ["lnum"] = vim.api.nvim_win_get_cursor(0)[1] - 1 })
end

-- Access the most severe diagnostic from the given list.
local function most_severe_diagnostic(diagnostics)
  local msd = nil
  for _, curd in pairs(diagnostics) do
    if msd == nil or msd.severity < curd.severity then
      msd = curd
    end
  end
  return msd
end

local ns = vim.api.nvim_create_namespace("current_line_diagnostic_virtual_text")

local function show_current_line_diagnostic(bufnr)
  local diagnostic = most_severe_diagnostic(current_line_diagnostics())
  vim.diagnostic.handlers.virtual_text.show(ns, bufnr, { diagnostic })
end

local function hide_current_line_diagnostic(bufnr)
  vim.diagnostic.handlers.virtual_text.hide(ns, bufnr)
end

vim.api.nvim_create_augroup("lsp_diagnostic_current_line", {
  clear = true,
})

function M.on_attach_diagnostic(bufnr)
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = "lsp_diagnostic_current_line",
  })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "lsp_diagnostic_current_line",
    buffer = bufnr,
    callback = function()
      hide_current_line_diagnostic(bufnr)
      show_current_line_diagnostic(bufnr)
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "lsp_diagnostic_current_line",
    buffer = bufnr,
    callback = function()
      hide_current_line_diagnostic(bufnr)
    end,
  })
end

return M
