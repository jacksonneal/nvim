-- ~/.config/nvim/after/ftplugin/haskell.lua
local ht = require("haskell-tools")
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts)
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)
-- Evaluate all code snippets
vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)
-- Toggle a GHCi repl for the current package
vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set("n", "<leader>rf", function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)

-- TODO: consolidate with lsp.lua
vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, { buffer = bufnr })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr })

vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { buffer = bufnr })
