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

  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = bufnr })
end

local function configure_lua(lspconfig)
  lspconfig.lua_ls.setup({
    diagnostics = {
      -- names to allow for unused variables
      unusedLocalExclude = { "_" },
    },
    on_attach = function(_, bufnr)
      on_attach_mappings(bufnr)
    end,
    on_init = function(client)
      -- access workspace path
      local path = client.workspace_folders[1].name
      if
        -- there is no workspace level config for lua-language-server
        not vim.loop.fs_stat(path .. "/.luarc.json")
        and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
      then
        -- setup server for neovim and config editing
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
          Lua = {
            runtime = {
              -- tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          },
        })

        -- notify client of new config
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      return true
    end,
  })
end

local function configure_python(lspconfig)
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
  })
end

local function configure_json(lspconfig)
  local jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
  jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true
  lspconfig.jsonls.setup({
    on_attach = function(_, bufnr)
      on_attach_mappings(bufnr)
    end,
    capabilities = jsonls_capabilities,
  })
end

local function configure_diagnostics()
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
  configure_lua(lspconfig)
  configure_python(lspconfig)
  configure_json(lspconfig)
  configure_diagnostics()
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
