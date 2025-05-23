-- Module for dependency and package manager plugins.

local function mason_nvim_config(_, opts)
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
end

local plugins = {
  {
    -- package manager
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "debugpy",
      },
    },
    config = mason_nvim_config,
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

return plugins
