---@module 'modules.lsp'
---LSP configuration for Neovim.
---
---Enables LSP servers, configures enhanced completion capabilities for all LSP
---servers, and provides buffer-local keymaps that are set when an LSP client
---attaches to a buffer. This module should be called after plugins are loaded
---to ensure cmp_nvim_lsp is available.
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

---Setup LSP servers, capabilities, and keymaps.
---
---Configures enhanced completion capabilities for all LSP servers via cmp-nvim-lsp,
---enables configured LSP servers based on config settings, and sets up the LspAttach
---autocommand for buffer-local keymaps.
---
---@return nil
function M.setup()
  -- Configure enhanced completion capabilities for all LSP servers
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  vim.lsp.config("*", { capabilities = capabilities })

  -- Load config settings
  local config = require("modules.config")
  local settings = config.settings

  -- Build list of enabled LSP servers based on config
  local enabled_servers = {}
  for server, opts in pairs(settings) do
    if opts.enable then
      table.insert(enabled_servers, server)
    end
  end

  -- Enable LSP servers
  if #enabled_servers > 0 then
    vim.lsp.enable(enabled_servers)
  end

  -- Setup keymaps when LSP attaches to a buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      setup_keymaps(bufnr)
    end,
  })
end

return M
