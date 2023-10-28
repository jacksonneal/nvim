-- Lsp configuration

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    ---@class PluginLspOpts
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      ---@class FormatPluginLspOpts
      format = {
        force = false,
        autoformat = true,
        format_notify = false,
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        clangd = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        pyright = {
          filetype = { "python" },
        },
      },
      setup = {},
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      ---@param on_attach fun(client, buffer)
      local util_on_attach = function(on_attach)
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
          end,
        })
      end

      -- diagnostics
      for name, icon in pairs(require("stardog.config").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- inlay hints
      if opts.inlay_hints.enabled and vim.lsp.buf.inlay_hint then
        util_on_attach(function(client, buffer)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.buf.inlay_hint(buffer, true)
          end
        end)
      end

      -- formatting
      require("stardog.plugins.nvim-lspconfig.format").setup(opts.format)

      -- keymaps on LspAttach
      util_on_attach(function(client, buffer)
        require("stardog.plugins.nvim-lspconfig.keymaps").on_attach(client, buffer)
      end)

      -- get all the servers that are available thourgh mason-lspconfig
      local mlsp = require("mason-lspconfig")
      local all_mslp_servers = {}
      all_mslp_servers =
        vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      -- configure lsp servers
      local servers = opts.servers
      local function setup(server)
        if not servers[server] then
          vim.notify("no config given for " .. server)
        end
        local server_opts = servers[server] or {}
        require("lspconfig")[server].setup(server_opts)
      end

      -- setup lsp servers, marking those to be managed by mason
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          -- not using mason, setup directly
          setup(server)
        else
          -- mark server to be installed and setup by mason
          ensure_installed[#ensure_installed + 1] = server
        end
      end

      -- mason ensure installed and setup servers
      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end,
  },
}
