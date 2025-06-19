-- Module for main plugin configurations.

local keymaps = require("core.keymaps") ---@module "core.keymaps"

return {
  {
    -- natural pine, faux fur, soho vibe colorscheme
    "rose-pine/neovim",
    -- alias so name is not "neovim"
    name = "rose-pine",
    -- load main colorscheme on startup
    lazy = false,
    -- ensure load before all other start plugins
    priority = 1000,
    -- Set colorscheme.
    config = function()
      vim.cmd.colorscheme("rose-pine-dawn")
    end,
  },
  {
    -- manage global and local project settings
    "folke/neoconf.nvim",
    -- lazy load on command
    cmd = "Neoconf",
    -- Setup plugin.
    config = function()
      -- setup neoconf
      require("neoconf").setup()
      -- load global settings
      require("core.config")
    end,
  },
  {
    -- LuaLS configuration for editing neovim config
    "folke/lazydev.nvim",
    -- lazy load on lua file
    ft = "lua",
    -- pass to `setup()`
    opts = {
      library = {
        -- load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    -- status line
    "nvim-lualine/lualine.nvim",
    -- load dependencies first
    dependencies = {
      -- file type icons and colors
      "nvim-tree/nvim-web-devicons",
    },
    -- execute empty `setup()`
    config = true,
  },
  {
    -- toggle and persist terminal windows
    "akinsho/toggleterm.nvim",
    -- pass to `setup()`
    opts = {
      -- keymap to toggle terminal windows
      open_mapping = [[<C-\>]],
      -- default terminal window size
      size = 18,
    },
  },
  {
    -- file explorer
    "nvim-tree/nvim-tree.lua",
    -- load dependencies first
    dependencies = {
      -- file type icons and colors
      "nvim-tree/nvim-web-devicons",
    },
    -- lazy load on keymap
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>", "Toggle tree." },
    },
    -- pass to `setup()`
    opts = function()
      local api = require("nvim-tree.api")

      -- Register keymaps for file tree buffer.
      ---@param bufnr number - buffer number of file explorer
      local function on_attach(bufnr)
        -- setup default mappings
        api.config.mappings.default_on_attach(bufnr)
        -- setup custom mappings
        keymaps.map(
          { "n" },
          "l",
          api.node.open.edit,
          { buffer = bufnr, desc = "Open node." }
        )
        vim.keymap.set(
          "n",
          "v",
          api.node.open.vertical,
          { buffer = bufnr, desc = "Open node in vsplit." }
        )
        keymaps.map(
          { "n" },
          "h",
          api.node.navigate.parent_close,
          { buffer = bufnr, desc = "Collapse node." }
        )
      end

      return { on_attach = on_attach }
    end,
  },
  {
    -- buffer header line
    "akinsho/bufferline.nvim",
    -- load dependencies first
    dependencies = {
      -- file type icons and colors
      "nvim-tree/nvim-web-devicons",
    },
    -- lazy load on buffer read or new file buffer
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    -- execute on startup
    init = function()
      -- register keymaps
      keymaps.map(
        { "n" },
        "<S-h>",
        ":BufferLineCyclePrev<CR>",
        { desc = "Cycle to previous buffer." }
      )
      keymaps.map(
        { "n" },
        "<S-l>",
        ":BufferLineCycleNext<CR>",
        { desc = "Cycle to next buffer." }
      )
      keymaps.map(
        { "n" },
        "<leader>bp",
        ":BufferLineTogglePin<CR>",
        { desc = "Toggle current buffer pin." }
      )
      keymaps.map(
        { "n" },
        "<leader>bP",
        ":BufferLineGroupClose ungrouped<CR>",
        { desc = "Close unpinned buffers." }
      )
    end,
    -- pass to `setup()`
    opts = {
      options = {
        -- integration with nvim LSP diagnostics
        diagnostics = "nvim_lsp",
        -- Display highest diagnostics level with total diagnostics count.
        ---@param count number
        ---@param level string
        diagnostics_indicator = function(count, level)
          local icon = level == "error" and " "
              or level == "warning" and " "
              or " "
          return " " .. icon .. count
        end,
        -- sloped style buffer separators
        separator_style = "slope",
        -- shift to accommodate file explorer
        offsets = {
          {
            filetype = "NvimTree",
            -- match highlight group of tree
            highlight = "Directory",
          },
        },
      },
    },
  },
  {
    -- buffer removal with intelligent selection of replacement buffer
    "echasnovski/mini.bufremove",
    -- lazy load on keymap
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete()
        end,
        desc = "Close current buffer.",
      },
    },
    -- execute empty `setup()`
    config = true,
  },
  {
    -- search
    "echasnovski/mini.pick",
    -- load search on startup
    lazy = false,
    -- keymaps
    keys = {
      {
        "<leader><leader>",
        ":Pick files tool='rg'<CR>",
        desc = "Search files.",
      },
      {
        "<leader>b",
        ":Pick buffers<CR>",
        desc = "Search buffers.",
      },
      {
        "<leader>/",
        ":Pick grep tool='rg'<CR>",
        desc = "Search global.",
      },
      {
        "<leader>R",
        ":Pick resume<CR>",
        desc = "Resume search.",
      },
    },
    -- pass to `setup()`
    opts = {
      mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
      },
    },
  },
  {
    -- surround actions
    "echasnovski/mini.surround",
    -- lazy load on buffer read or new file buffer
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    -- execute empty `setup()`
    config = true,
  },
  {
    -- comment lines
    "echasnovski/mini.comment",
    -- lazy load on buffer read or new file buffer
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    -- execute empty `setup()`
    config = true,
  },
  {
    -- autopairs
    "echasnovski/mini.pairs",
    -- lazy load on insert mode
    event = "InsertEnter",
    -- execute empty `setup()`
    config = true,
  },
  {
    -- syntax highlighting
    "nvim-treesitter/nvim-treesitter",
    -- lazy load on buffer read or new file buffer
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    -- pass to `setup()`
    opts = {
      highlight = {
        -- enable syntax highlighting
        enable = true,
        -- disable parsers
        disable = {
          -- tsx highlight is broken
          "tsx",
          -- vimdoc highlight looks awful
          "vimdoc",
        },
      },
      -- install language parsers
      ensure_installed = {
        "cpp",
        "graphql",
        "haskell",
        "html",
        "javascript",
        "json",
        "jsonc",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "python",
        "scss",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
        "zig",
      },
      -- node selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    -- override to call setup on correct module
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    -- DAP client
    "mfussenegger/nvim-dap",
    -- lazy load on keymap
    keys = {
      {
        "<leader>db",
        ":DapToggleBreakpoint<CR>",
        desc = "Toggle breakpoint.",
      },
      { "<leader>dl", ":DapLogBreakpoint<CR>", desc = "Log breakpoint." },
      {
        "<leader>dc",
        ":DapConditionBreakpoint<CR>",
        desc = "Conditional breakpoint.",
      },
      { "<leader>di", ":DapStepInto<CR>",      desc = "Step into." },
      { "<leader>dp", ":DapStepOver<CR>",      desc = "Step over." },
      { "<leader>dP", ":DapContinue<CR>",      desc = "Continue." },
      { "<leader>dr", ":DapRestart<CR>",       desc = "Restart." },
      { "<leader>dq", ":DapTerminate<CR>",     desc = "Terminate." },
    },
    -- setup plugin
    config = function()
      local dap = require("dap")

      -- python executable file
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data")
            .. "/mason/packages/debugpy/venv/bin/python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.getcwd() .. "/.venv/bin/python"
          end,
          env = {
            PYTHONPATH = vim.fn.getcwd(),
          },
        },
      }
    end,
    -- execute on startup
    init = function()
      local dap = require("dap")
      -- user command to set conditional breakpoint
      vim.api.nvim_create_user_command("DapConditionBreakpoint", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, {})
      -- user command to set log breakpoint
      vim.api.nvim_create_user_command("DapLogBreakpoint", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, {})
      -- user command to restart active session
      vim.api.nvim_create_user_command("DapRestart", function()
        local restarted = false
        dap.terminate()
        dap.listeners.after.event_terminated["restart_dap"] = function()
          if not restarted then
            restarted = true
            dap.run_last()
          end
        end
      end, {})
    end,
  },
  {
    -- DAP UI
    "rcarriga/nvim-dap-ui",
    -- load dependencies first
    dependencies = {
      -- DAP client
      "mfussenegger/nvim-dap",
      -- DAP virtual text
      "theHamsta/nvim-dap-virtual-text",
    },
    -- lazy load on keymap
    keys = {
      { "<leader>du", ":DapUiToggle<CR>", desc = "Toggle UI." },
    },
    -- pass to `setup()`
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.45 },
            { id = "breakpoints", size = 0.30 },
            { id = "stacks",      size = 0.25 },
          },
          size = 50,
          position = "right",
        },
        {
          elements = {
            "repl",
          },
          size = 18,
          position = "bottom",
        },
      },
    },
    -- execute on startup
    init = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- open DAP UI on session start
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- user command to toggle DAP UI
      vim.api.nvim_create_user_command("DapUiToggle", function()
        require("dapui").toggle()
      end, {})
    end,
  },
  {
    -- DAP virtual text
    "theHamsta/nvim-dap-virtual-text",
    -- execute empty `setup()`
    config = true,
  },
  {
    -- Current line diagnostic virtual text.
    "jacksonneal/jax.cur_ln_dx",
    -- local module
    main = "jax.cur_ln_dx",
    dev = true,
    opts = { is_enabled = true },
  },
  {
    -- Current line git blame virtual text.
    "jacksonneal/jax.cur_ln_blame",
    -- local module
    main = "jax.cur_ln_blame",
    dev = true,
    -- lazy load on keymap
    keys = {
      {
        "<leader>gb",
        "<cmd>CurLnBlameToggle<cr>",
        desc = "Toggle current line git blame",
      },
    },
    config = true,
  },
  {
    -- Package manager
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "debugpy",
      },
    },
    -- setup and configure
    config = function(_, opts)
      require("mason").setup()

      local function mason_install_all()
        local mr = require("mason-registry")

        local function inner()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              vim.notify("Installing " .. tool)
              p:install()
            else
              vim.notify("Skipping " .. tool .. ", already installed")
            end
          end
        end

        mr.refresh(inner)
      end

      vim.api.nvim_create_user_command("MasonInstallAll", mason_install_all, {})
    end,
  },
  {
    -- install LSP servers
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason.nvim",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "denols",
        "eslint",
        "jsonls",
        "lua_ls",
        "pyright",
        "ruff_lsp",
        "tailwindcss",
        "tsserver",
        "volar",
        "zls",
      },
    },
  },
}
