-- Neovim config entrypoint.

require("config.lazy")

-- setup plugins using lazy.nvim
require("lazy").setup("plugins")

-- setup config module
require("config").setup()
