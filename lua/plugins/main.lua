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
      require("rose-pine").setup({
        styles = {
          italic = false
        }
      })
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
      {
        "<leader>f<leader>",
        function()
          vim.ui.input(
            { prompt = "File/path pattern (e.g., api, *.lua, src/**/test): " },
            function(pattern)
              if pattern and pattern ~= "" then
                local pick = require("mini.pick")

                -- Smart pattern expansion for path matching
                local glob_pattern = pattern
                -- If pattern doesn't contain path separators or glob syntax, make it match paths too
                if not pattern:match("[/%*%?%[%]]") then
                  -- Simple word like "api" becomes "**/*api*/**/*"
                  glob_pattern = "**/*" .. pattern .. "*/**/*"
                elseif pattern:match("^%*[^/]+%*$") then
                  -- Pattern like "*api*" becomes "**/*api*/**/*"
                  local word = pattern:match("^%*(.+)%*$")
                  glob_pattern = "**/*" .. word .. "*/**/*"
                end

                -- Try both the expanded pattern and the original filename pattern
                local cmd
                if glob_pattern ~= pattern then
                  -- Use both patterns to match files in matching dirs AND files with matching names
                  cmd = {
                    "rg",
                    "--files",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "-g",
                    glob_pattern,
                    "-g",
                    pattern,
                  }
                else
                  -- User provided specific pattern, use as-is
                  cmd = {
                    "rg",
                    "--files",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "-g",
                    pattern,
                  }
                end

                pick.builtin.cli({
                  command = cmd,
                  spawn_opts = { cwd = vim.fn.getcwd() },
                }, {
                  source = {
                    name = string.format("Files matching: %s", pattern),
                    show = pick.default_show,
                    choose = pick.default_choose,
                  },
                })
              end
            end
          )
        end,
        desc = "Search files by glob pattern (matches paths and filenames).",
      },
      {
        "<leader>f/",
        function()
          vim.ui.input(
            { prompt = "File/path pattern (e.g., api, *.lua, src/**/test): " },
            function(pattern)
              if pattern and pattern ~= "" then
                vim.ui.input({ prompt = "Search pattern: " }, function(search)
                  if search and search ~= "" then
                    local pick = require("mini.pick")

                    -- Smart pattern expansion for path matching
                    local glob_pattern = pattern
                    -- If pattern doesn't contain path separators or glob syntax, make it match paths too
                    if not pattern:match("[/%*%?%[%]]") then
                      -- Simple word like "api" becomes "**/*api*/**/*"
                      glob_pattern = "**/*" .. pattern .. "*/**/*"
                    elseif pattern:match("^%*[^/]+%*$") then
                      -- Pattern like "*api*" becomes "**/*api*/**/*"
                      local word = pattern:match("^%*(.+)%*$")
                      glob_pattern = "**/*" .. word .. "*/**/*"
                    end

                    -- Build ripgrep command with glob filter
                    local cmd = {
                      "rg",
                      "--column",
                      "--line-number",
                      "--no-heading",
                      "--smart-case",
                      "--color=never",
                    }

                    if glob_pattern ~= pattern then
                      -- Use both patterns to match files in matching dirs AND files with matching names
                      table.insert(cmd, "-g")
                      table.insert(cmd, glob_pattern)
                      table.insert(cmd, "-g")
                      table.insert(cmd, pattern)
                    else
                      -- User provided specific pattern, use as-is
                      table.insert(cmd, "-g")
                      table.insert(cmd, pattern)
                    end

                    table.insert(cmd, "--")
                    table.insert(cmd, search)

                    pick.builtin.cli({
                      command = cmd,
                      spawn_opts = { cwd = vim.fn.getcwd() },
                    }, {
                      source = {
                        name = string.format(
                          "Grep '%s' in: %s",
                          search,
                          pattern
                        ),
                        show = pick.default_show,
                        choose = function(item)
                          if item == nil then
                            return
                          end
                          -- Parse the grep output (file:line:col:text)
                          local parts = vim.split(item, ":")
                          if #parts >= 3 then
                            local file = parts[1]
                            local line = tonumber(parts[2]) or 1
                            local col = tonumber(parts[3]) or 1
                            -- Schedule the file opening to happen after picker closes
                            vim.schedule(function()
                              -- Open the file with proper escaping
                              vim.cmd.edit(vim.fn.fnameescape(file))
                              -- Set cursor position after file is loaded
                              vim.api.nvim_win_set_cursor(0, { line, col - 1 })
                              -- Center the view on the cursor line
                              vim.cmd("normal! zz")
                              -- Force redraw to ensure focus
                              vim.cmd("redraw!")
                            end)
                          end
                        end,
                      },
                    })
                  end
                end)
              end
            end
          )
        end,
        desc = "Grep in files matching glob pattern (matches paths and filenames).",
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
        "tailwindcss",
        "tsserver",
        "volar",
        "zls",
      },
    },
  },
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
  },
  {
    -- Haskell tooling
    "mrcjkb/haskell-tools.nvim",
    -- lazy load on these file types
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  },
  {
    -- completion engine
    "hrsh7th/nvim-cmp",
    -- lazy load on insert mode
    event = "InsertEnter",
    dependencies = {
      -- configs for neovim LSP client
      "nvim-lspconfig",
      -- completion source for neovim LSP client
      "hrsh7th/cmp-nvim-lsp",
      -- completion source for neovim Lua API
      "hrsh7th/cmp-nvim-lua",
      -- snippet engine
      "L3MON4D3/LuaSnip",
      -- completion source for LuaSnip
      "saadparwaiz1/cmp_luasnip",
      -- completion source for buffer words
      "hrsh7th/cmp-buffer",
      -- completion source for filesystem paths
      "hrsh7th/cmp-path",
      -- completion source for emojis
      "hrsh7th/cmp-emoji",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- determine if character before cursor is not a space
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api
            .nvim_buf_get_lines(0, line - 1, line, true)[1]
            :sub(col, col)
            :match("%s")
            == nil
      end

      return {
        -- provide a snippet engine
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        -- completion sources
        sources = cmp.config.sources({
          -- appear in options in reverse order
          { name = "emoji" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "lazydev" },
        }),
        -- custom mappings
        mapping = {
          -- cycle through options
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- menu is visible, go to next option
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              -- can either expand or jump in snippet
              luasnip.expand_or_jump()
            elseif has_words_before() then
              -- non-space characters before cursor, try to complete word
              cmp.complete()
            else
              fallback()
            end
          end),
          -- cycle in reverse
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- menu is visible, go to previous option
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              -- can jump backwards in snippet
              luasnip.jump(-1)
            else
              fallback()
            end
          end),
          -- select option
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              -- menu is visible with active option
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
            else
              fallback()
            end
          end),
        },
        -- experimental options
        experimental = {
          -- completion ghost text appears like comments
          ghost_text = {
            hl_group = "Comment",
          },
        },
      }
    end,
  },
}
