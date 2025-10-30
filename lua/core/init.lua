-- configure vim options
require("core.options")
-- configure file type detection
require("core.filetype")
-- configure keymaps
require("core.keymaps")
-- configure autocommands
require("core.autocommands")
-- configure diagnostics
require("modules.diagnostics").setup()

-- bootstrap lazy.nvim
require("core.lazy_bootstrap")
-- setup plugins
require("lazy").setup("plugins", {
  dev = {
    path = "~/.config/nvim/jacksonneal",
    pattern = { "jacksonneal" },
  },
})

-- configure LSP (after plugins are loaded)
require("modules.lsp").setup()
