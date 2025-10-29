---@module 'modules.lsp'
---LSP configuration for Neovim.
---
---Provides buffer-local keymaps that are set when an LSP client attaches to a
---buffer. This module should be called during core initialization to ensure the
---LspAttach autocommand is registered before any LSP servers start.
---
---Keymaps (buffer-local, set on LSP attach):
--- - `gd`: Go to definition
--- - `gr`: Show references
--- - `<leader>ca`: Code actions
--- - `<leader>cr`: Rename symbol
--- - `<leader>f`: Format buffer
---
---@see vim.lsp
---@see https://neovim.io/doc/user/lsp.html

---@class Lsp
local M = {}

---Configure LSP keymaps for a buffer.
---
---This is called automatically via the LspAttach autocommand whenever an LSP
---client attaches to a buffer.
---
---@param bufnr integer The buffer number
---@return nil
local function setup_keymaps(bufnr)
  vim.keymap.set(
    "n",
    "gd",
    vim.lsp.buf.definition,
    { buffer = bufnr, desc = "Go to definition" }
  )
  vim.keymap.set(
    "n",
    "gr",
    vim.lsp.buf.references,
    { buffer = bufnr, desc = "Show references" }
  )
  vim.keymap.set(
    "n",
    "<leader>ca",
    vim.lsp.buf.code_action,
    { buffer = bufnr, desc = "Code actions" }
  )
  vim.keymap.set(
    "n",
    "<leader>cr",
    vim.lsp.buf.rename,
    { buffer = bufnr, desc = "Rename symbol" }
  )
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = bufnr, desc = "Format buffer" })
end

---Setup LSP keymaps via LspAttach autocommand.
---@return nil
function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      setup_keymaps(bufnr)
    end,
  })
end

return M
