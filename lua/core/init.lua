local lazy = require("core.lazy")
local settings = require("core.settings")

settings.setup()
local config = settings.config

require("core.options")
require("core.keymaps")
require("core.autocommands")
require("core.format")

vim.cmd.colorscheme(config.colorscheme)

lazy.bootstrap()

require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "lua_ls" },
        },
      },
    },
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  {
    -- a file explorer
    "nvim-tree/nvim-tree.lua",
    cmd = {
      -- open or close the tree
      "NvimTreeToggle",
      -- open the tree if closed, then focus the tree
      "NvimTreeFocus",
    },
    dependencies = {
      -- display file icons
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", "Toggle tree" },
      { "<C-e>", "<cmd>NvimTreeFocus<cr>", "Focus tree" },
    },
    opts = {
      -- called on attachment to buffer
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- mapping options
        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            -- create buffer-local mapping
            buffer = bufnr,
            -- non-recursive map
            noremap = true,
            -- do not echo to command line
            silent = true,
            -- execute as soon as match found, do not wait for other keys
            nowait = true,
          }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- if folder, toggle open/close
        -- if file, open
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))

        -- if folder, toggle open/close
        -- if file, open in v-split
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open v-split"))

        -- if folder, expand all children
        -- if file, expand all folders in project
        vim.keymap.set("n", "L", api.tree.expand_all, opts("Expand all"))

        -- if expanded folder, collapse
        -- if collapsed folder or file, collapse parent
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Collapse"))

        -- collapse all folders in project
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse all"))
      end,
    },
  },
})

local cmp = require("cmp")
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["lua_ls"].setup({
  capabilities = capabilities,
})
