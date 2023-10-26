local lazy = require("core.lazy-bootstrap")
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
    -- package manager
    "williamboman/mason.nvim",
    -- empty opts so lazy.nvim calls Plugin.config
    opts = {},
  },
  {
    -- bridge mason and lspconfig, supporting installation
    -- and configuration of LSP servers
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason.nvim",
    },
    opts = {
      -- list of servers to automatically install
      ensure_installed = {
        -- lua-language-server
        "lua_ls",
      },
    },
  },
  {
    -- configs for neovim LSP client
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
  },
  {
    -- a completion engine
    "hrsh7th/nvim-cmp",
    -- just before starting Insert mode
    event = "InsertEnter",
    dependencies = {
      -- configs for neovim LSP client
      "nvim-lspconfig",
      -- source for neovim LSP client
      "hrsh7th/cmp-nvim-lsp",
      -- source for neovim Lua API
      "hrsh7th/cmp-nvim-lua",
      -- snippet engine
      "L3MON4D3/LuaSnip",
      -- source for LuaSnip
      "saadparwaiz1/cmp_luasnip",
      -- source for buffer words
      "hrsh7th/cmp-buffer",
      -- source for filesystem paths
      "hrsh7th/cmp-path",
      -- source for emojis
      "hrsh7th/cmp-emoji",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- determine if character before cursor is not a space
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
            == nil
      end

      return {
        -- provide a snippet engine
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        -- provide completion sources
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
        }),
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
        experimental = {
          -- completion ghost text appears like comments
          ghost_text = {
            hl_group = "Comment",
          },
        },
      }
    end,
  },
  {
    -- file explorer
    "nvim-tree/nvim-tree.lua",
    cmd = {
      -- toggle open/close the tree
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

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["lua_ls"].setup({
  capabilities = capabilities,
})
