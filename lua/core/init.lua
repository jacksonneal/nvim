-- configure settings
local config = require("core.config")
config.setup()

-- configure vim options
require("core.options")
-- configure file type detection
require("core.filetype")
-- configure keymaps
require("core.keymaps")
-- configure autocommands
require("core.autocommands")

-- bootstrap lazy.nvim
require("core.lazy_bootstrap")
-- setup plugins
require("lazy").setup("plugins")
