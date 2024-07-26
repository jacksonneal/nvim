-- Module for LSP plugins

local settings = require("core.config").settings

local function configure_diagnostics()
  vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float)
  vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<leader>da", vim.diagnostic.setloclist)
  vim.diagnostic.config({
    virtual_text = false,
  })
end

local function on_attach_mappings(bufnr)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  -- TODO: conflicts with window navigation
  -- vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, { buffer = bufnr })

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

local function on_attach(bufnr)
  local cur_ln_dx = require("jax.cur_ln_dx")
  cur_ln_dx.on_attach_dx(bufnr)
  on_attach_mappings(bufnr)
end

local function configure_lua(lspconfig, capabilities)
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    diagnostics = {
      -- names to allow for unused variables
      unusedLocalExclude = { "_" },
    },
    on_attach = function(_, bufnr)
      on_attach(bufnr)
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
              -- (most likely LuaJIT in the case of neovim)
              version = "LuaJIT",
            },
            -- make the server aware of neovim runtime files
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

local function configure_python(lspconfig, capabilities)
  lspconfig.ruff_lsp.setup({
    on_attach = function(client)
      -- defer hover to other LSP server
      client.server_capabilities.hoverProvider = false
    end,
  })
  lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      on_attach(bufnr)
    end,
    settings = {
      python = {
        pythonPath = settings.pyright.pythonPath or vim.fn.exepath("python")
      }
    },
  })
end

local function configure_eslint(lspconfig, capabilities)
  lspconfig.eslint.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
      on_attach(bufnr)
    end,
  })
end

local function configure_json(lspconfig, capabilities)
  lspconfig.jsonls.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      on_attach(bufnr)
    end,
  })
end

local function configure_tailwind(lspconfig, capabilities)
  if settings.tailwindcss.disable then
    return
  end

  lspconfig.tailwindcss.setup({
    capabilities = capabilities,
  })
end

local function configure_typescript(lspconfig, capabilities)
  if settings.tsserver.disable then
    return
  end

  lspconfig.tsserver.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      on_attach(bufnr)
    end,
  })
end

local function configure_vue(lspconfig, capabilities)
  if settings.volar.disable then
    return
  end

  local util = require("lspconfig.util")
  local function get_typescript_server_path(root_dir)
    local found_ts = nil
    local function check_dir(path)
      found_ts = util.path.join(path, "node_modules", "typescript", "lib")
      if util.path.exists(found_ts) then
        return path
      end
    end
    if util.search_ancestors(root_dir, check_dir) then
      return found_ts
    else
      error("Could not find tsserver install")
    end
  end

  lspconfig.volar.setup({
    capabilities = capabilities,
    filetypes = { "vue", "typescript", "javascript" },
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(bufnr)
    end,
    on_new_config = function(config, root_dir)
      config.init_options.typescript.tsdk = get_typescript_server_path(root_dir)
    end,
  })
end

local function configure_zig(lspconfig, capabilities)
  lspconfig.zls.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      on_attach(bufnr)
    end,
  })
end

local function nvim_lspconfig_config()
  configure_diagnostics()

  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  configure_eslint(lspconfig, capabilities)
  configure_json(lspconfig, capabilities)
  configure_lua(lspconfig, capabilities)
  configure_python(lspconfig, capabilities)
  configure_tailwind(lspconfig, capabilities)
  configure_typescript(lspconfig, capabilities)
  configure_vue(lspconfig, capabilities)
  configure_zig(lspconfig, capabilities)
end

return {
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
