local config = require("core.config")
config.setup()

-- configure vim options
require("core.options")
-- configure keymaps
require("core.keymaps")
-- configure autocommands
require("core.autocommands")
-- configure static analysis
require("core.static_analysis")

-- bootstrap lazy.nvim
require("core.lazy_bootstrap")

-- setup plugins
require("lazy").setup({
  { import = "plugins" },
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dL",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Log breakpoint",
      },
      {
        "<leader>dR",
        function()
          require("dap").repl.open()
        end,
        desc = "Open REPL",
      },
      {
        "<F4>",
        "<cmd>DapTerminate<cr>",
        desc = "Terminate",
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<F6>",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<F7>",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<F8>",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mason.nvim",
      "nvim-dap",
      "nvim-dap-ui",
    },
    keys = {
      {
        "<leader>dr",
        function()
          require("dap-python").test_method()
        end,
        "Test method",
      },
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("dap-python").resolve_python = function()
        local cwd = vim.fn.getcwd()
        return cwd .. "/venv/bin/python"
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-dap",
    },
    keys = {
      {
        "<F9>",
        function()
          local dapui = require("dapui")
          dapui.close()
        end,
      },
      {
        "<F10>",
        function()
          local dapui = require("dapui")
          dapui.open()
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated["dapui_config"] = function()
        -- dapui.close()
      end
      dap.listeners.after.event_exited["dapui_config"] = function()
        -- dapui.close()
      end
    end,
  },
  {
    -- configs for neovim LSP client
    "neovim/nvim-lspconfig",
    event = {
      -- before reading a file into a buffer
      "BufReadPre",
      -- before editing a new file
      "BufNewFile",
    },
    dependencies = {
      -- package manager
      "mason.nvim",
      -- bridge mason and lspconfig with installation and configuration of LSP servers
      "mason-lspconfig.nvim",
      -- completion source for neovim LSP client
      "cmp-nvim-lsp",
    },
  },
})

-- configure LSP servers
local lspconfig = require("lspconfig")

-- access completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- configure jedi-language-server
lspconfig.jedi_language_server.setup({})

-- configure ruff-lsp
lspconfig.ruff_lsp.setup({
  -- set completion capabilities
  -- capabilities = capabilities,
  -- on buffer attach
  on_attach = function(_, bufnr)
    -- hover info
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    -- goto definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    -- goto type definition
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
    -- goto implementation
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

    -- show line diagnostic
    vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, { buffer = bufnr })
    -- goto next diagnostic
    vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = bufnr })
    -- goto previous diagnostic
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = bufnr })

    -- show code action
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
  end,
  init_options = {
    settings = {
      args = {},
    },
  },
})

-- configure lua-language-server
lspconfig.lua_ls.setup({
  -- set completion capabilities
  capabilities = capabilities,
  -- diagnostics configuration
  diagnostics = {
    -- names to allow for unused variables
    unusedLocalExclude = { "_" },
  },
  -- on buffer attach
  on_attach = function(_, bufnr)
    -- hover info
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    -- goto definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    -- goto type definition
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
    -- goto implementation
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

    -- show line diagnostic
    vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, { buffer = bufnr })
    -- goto next diagnostic
    vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = bufnr })
    -- goto previous diagnostic
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = bufnr })

    -- show code action
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
  end,
  -- on server init
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

-- configure diagnostics
vim.diagnostic.config({
  -- no inline virtual diagnostic text
  virtual_text = false,
})
