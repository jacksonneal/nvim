return {
  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          -- nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.flake8,
          nls.builtins.formatting.black,
        },
      }
    end,
  },
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
      diagnostics = {
        virtual_text = false,
      },
    },
  },
  -- add hls
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hls = {},
      },
      setup = {
        {
          filetypes = { "haskell", "lhaskell", "cabal" },
          cmd = { "haskell-language-server-wrapper", "--lsp" },
          haskell = {
            cabalFormattingProvider = "cabalfmt",
            formattingProvider = "ormolu",
          },
          single_file_support = true,
        },
      },
    },
  },
  -- add html
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
      },
      setup = {
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = "auto",
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  },
  -- add vue
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {},
      },
      setup = {
        filetypes = {
          "typescript",
          "javascript",
          "vue",
          "json",
        },
      },
    },
  },
}
