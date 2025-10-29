---@module 'modules.diagnostics'
---Diagnostic configuration for Neovim.
---
---Provides diagnostic display configuration and navigation keymaps. Virtual lines
---are shown when jumping to diagnostics. This module should be called during core
---initialization to ensure diagnostics are properly configured before any LSP
---servers attach.
---
---Keymaps:
--- - `<leader>ds`: Open diagnostic float window
--- - `<leader>dj`: Go to next diagnostic
--- - `<leader>dk`: Go to previous diagnostic
--- - `<leader>da`: Add diagnostics to location list
---
---@see vim.diagnostic
---@see https://neovim.io/doc/user/diagnostic.html

---@class Diagnostics
local M = {}

---Namespace for virtual lines shown on diagnostic jump
local virt_lines_ns = vim.api.nvim_create_namespace("on_diagnostic_jump")

---Callback to show virtual lines when jumping to a diagnostic.
---@param diagnostic vim.Diagnostic?
---@param bufnr integer
local function on_jump(diagnostic, bufnr)
  if not diagnostic then
    return
  end

  vim.diagnostic.show(
    virt_lines_ns,
    bufnr,
    { diagnostic },
    { virtual_lines = { current_line = true } }
  )
end

---Configure diagnostic keymaps and display.
---@return nil
function M.setup()
  -- Setup display of virtual text on the current line when jumping to a diagnostic
  vim.diagnostic.config({
    jump = { on_jump = on_jump },
  })

  vim.keymap.set(
    "n",
    "<leader>ds",
    vim.diagnostic.open_float,
    { desc = "Open diagnostic float window" }
  )
  vim.keymap.set(
    "n",
    "<leader>dj",
    vim.diagnostic.goto_next,
    { desc = "Go to next diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>dk",
    vim.diagnostic.goto_prev,
    { desc = "Go to previous diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>da",
    vim.diagnostic.setloclist,
    { desc = "Add diagnostics to location list" }
  )
end

return M
