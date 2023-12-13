-- Module for diagnostics.

local M = {}

local function current_line_diagnostics()
  return vim.diagnostic.get(0, { ["lnum"] = vim.api.nvim_win_get_cursor(0)[1] - 1 })
end

local function most_severe_diagnostic(diagnostics)
  local msd = nil
  for _, curd in pairs(diagnostics) do
    if msd == nil or msd.severity < curd.severity then
      msd = curd
    end
  end
  return msd
end

local ns = vim.api.nvim_create_namespace("current_line_virtual_text")

vim.diagnostic.handlers.current_line_virt = {
  show = function(_, bufnr, diagnostics, _)
    local diagnostic = most_severe_diagnostic(diagnostics)
    if not diagnostic then
      return
    end

    pcall(
      vim.diagnostic.handlers.virtual_text.show,
      ns,
      bufnr,
      { diagnostic }
    )
  end,
  hide = function(_, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.diagnostic.handlers.virtual_text.hide(ns, bufnr or 0)
  end,
}

vim.api.nvim_create_augroup("lsp_diagnostic_current_line", {
  clear = true,
})

function M.on_attach_diagnostics(bufnr)
  vim.api.nvim_clear_autocmds {
    buffer = bufnr,
    group = "lsp_diagnostic_current_line",
  }

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "lsp_diagnostic_current_line",
    buffer = bufnr,
    callback = function()
      print("cursor hold")
      vim.diagnostic.handlers.current_line_virt.hide(nil, nil)
      vim.diagnostic.handlers.current_line_virt.show(
        nil,
        0,
        current_line_diagnostics(),
        nil
      )
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "lsp_diagnostic_current_line",
    buffer = bufnr,
    callback = function()
      print("cursor moved")
      vim.diagnostic.handlers.current_line_virt.hide(nil, nil)
    end,
  })
end

return M
