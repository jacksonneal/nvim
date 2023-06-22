-- Neovim config entrypoint.

-- setup config module
require("config").setup()

-- setup plugins using lazy.nvim
require("lazy").setup("plugins")
