return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "black",
      },
    },
  },
}
