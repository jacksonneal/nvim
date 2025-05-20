-- Module for editor experience plugins.

local function nvim_treesitter_config(_, opts)
  require("nvim-treesitter.configs").setup(opts)
end

local plugins = {
  {
    -- syntax highlighting
    "nvim-treesitter/nvim-treesitter",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    opts = {
      highlight = {
        enable = true,
        disable = {
          -- tsx highlight is broken
          "tsx",
          -- vimdoc highlight looks aweful
          "vimdoc",
        },
      },
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
    config = nvim_treesitter_config,
  },
}

return plugins
