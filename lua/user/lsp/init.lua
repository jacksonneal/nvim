-- Must load plugins in the following order
require("user.lsp.mason")
require("user.lsp.mason_lspconfig")
require("user.lsp.lspconfig")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
