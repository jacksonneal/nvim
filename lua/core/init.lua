-- configure vim options
require("core.options")
-- configure file type detection
require("core.filetype")
-- configure keymaps
require("core.keymaps")
-- configure autocommands
require("core.autocommands")

require("core.globals")

-- bootstrap lazy.nvim
require("core.lazy_bootstrap")
-- setup plugins
require("lazy").setup("plugins", {
  dev = {
    path = "~/.config/nvim/jacksonneal",
    pattern = { "jacksonneal" },
  },
})

-- require("core.config")
