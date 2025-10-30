-- Module for LSP plugins

local function on_attach(bufnr)
  local cur_ln_dx = require("jax.cur_ln_dx")
  cur_ln_dx.on_attach_dx(bufnr)
end

local function configure_json(lspconfig, capabilities)
  lspconfig.jsonls.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      on_attach(bufnr)
    end,
  })
end

local function nvim_lspconfig_config()
  vim.lsp.enable({
    "denols",
    "eslint",
    "jsonls",
    "lua_ls",
    "pyright",
    "ruff",
    "tailwindcss",
    "ts_ls",
  })

  -- local lspconfig = require("lspconfig")
  -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- configure lua_ls
  -- use empty config here, lazydev.nvim sets config
  -- lspconfig.lua_ls.setup({
  --   capabilities = capabilities,
  --   on_attach = function(_, bufnr)
  --     on_attach(bufnr)
  --   end,
  -- })

  -- configure_deno(lspconfig, capabilities)
  -- configure_json(lspconfig, capabilities)
end

return {
  {
    -- LSP server configurations for Nvim LSP client
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "cmp-nvim-lsp",
      "folke/neoconf.nvim",
    },
    config = nvim_lspconfig_config,
  },
}
