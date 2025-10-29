---@module 'diagnostics'
---Diagnostic configuration for Neovim.
---
---Provides diagnostic display configuration, navigation keymaps, and toggle
---functionality for virtual lines. This module should be called during core
---initialization to ensure diagnostics are properly configured before any
---LSP servers attach.
---
---Keymaps:
--- - `<leader>ds`: Open diagnostic float window
--- - `<leader>dj`: Go to next diagnostic
--- - `<leader>dk`: Go to previous diagnostic
--- - `<leader>da`: Add diagnostics to location list
---
---Commands:
--- - `CurLnDxToggle`: Toggle virtual lines for current line diagnostics
---
---@see vim.diagnostic
---@see https://neovim.io/doc/user/diagnostic.html

---@class Diagnostics
---@field setup fun(): nil Configure diagnostic keymaps and commands
---@field toggle_virtual_lines fun(): nil Toggle virtual lines display for the current line
local M = {}

---State tracking for virtual lines on current line
---@type boolean
local virtual_lines_enabled = false

---Toggle virtual lines display for the current line.
---@return nil
function M.toggle_virtual_lines()
  virtual_lines_enabled = not virtual_lines_enabled
  vim.diagnostic.config({
    virtual_lines = { current_line = virtual_lines_enabled },
    virtual_text = false,
  })

  local status = virtual_lines_enabled and "enabled" or "disabled"
  vim.notify("Virtual lines " .. status, vim.log.levels.INFO)
end

---Configure diagnostic keymaps and commands.
---@return nil
function M.setup()
  vim.diagnostic.config({
    virtual_lines = { current_line = virtual_lines_enabled },
    virtual_text = false,
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

  vim.api.nvim_create_user_command(
    "CurLnDxToggle",
    M.toggle_virtual_lines,
    { desc = "Toggle virtual lines for current line diagnostics" }
  )
end

return M
