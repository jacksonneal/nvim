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
      ensure_installed = {
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "python",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
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
  {
    -- surround actions
    "echasnovski/mini.surround",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    config = true,
  },
  {
    -- comment lines
    "echasnovski/mini.comment",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    config = true,
  },
  {
    -- autopairs
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = true,
  },
}

return plugins
