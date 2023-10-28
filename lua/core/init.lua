local const = require("const")
local file = require("util.file")
local settings = require("core.settings")
local shell = require("util.shell")

settings.setup()
local config = settings.config

require("core.options")
require("core.keymaps")
require("core.autocommands")
require("core.format")
vim.cmd.colorscheme(config.colorscheme)

-- bootstrap lazy.nvim package manager
if not file.is_dir(const.LAZY_PATH) then
  -- clone repo
  shell.call(const.LAZY_CLONE_CMD)
end
-- add to runtime path
vim.opt.rtp:prepend(const.LAZY_PATH)

require("lazy").setup({
  {
    -- minimal and fast autopairs
    "echasnovski/mini.pairs",
    -- just before starting Insert mode
    event = "InsertEnter",
    -- empty opts so lazy.nvim calls Plugin.config
    opts = {},
  },
  {
    -- package manager
    "williamboman/mason.nvim",
    -- empty opts so lazy.nvim calls Plugin.config
    opts = {},
  },
  {
    -- bridge mason and lspconfig with installation and configuration of LSP servers
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
  {
    -- a completion engine
    "hrsh7th/nvim-cmp",
    -- just before starting Insert mode
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
        -- completion sources
        sources = cmp.config.sources({
          -- appear in options in reverse order
          { name = "emoji" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
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
      -- toggle open/close the tree
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", "Toggle tree" },
      -- open the tree if closed, then focus the tree
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

-- access completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- configure lua-language-server
require("lspconfig").lua_ls.setup({
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
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.implementation, { buffer = bufnr })
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