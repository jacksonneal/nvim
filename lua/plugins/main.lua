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
}
