-- Module for LSP plugins.

local function on_attach_mappings(bufnr)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, { buffer = bufnr })

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr })
end

local function setup_diagnostics()
  vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float)
  vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<leader>da", vim.diagnostic.setloclist)
  vim.diagnostic.config({
    virtual_text = false,
  })
end

local function nvim_lspconfig_config()
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Python LSP servers
  lspconfig.ruff_lsp.setup({
    on_attach = function(client)
      -- defer hover to other LSP server
      client.server_capabilities.hoverProvider = false
    end,
  })
  lspconfig.pyright.setup({
    on_attach = function(_, bufnr)
      on_attach_mappings(bufnr)
    end,
    capabilities = capabilities,
  })

  setup_diagnostics()
end

local plugins = {
  {
    -- configs for neovim LSP client
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "cmp-nvim-lsp",
    },
    config = nvim_lspconfig_config,
  },
}

return plugins
