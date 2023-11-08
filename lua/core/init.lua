-- configure settings
local config = require("core.config")
config.setup()

-- configure vim options
require("core.options")
-- configure keymaps
require("core.keymaps")
-- configure autocommands
require("core.autocommands")
-- configure static analysis
require("core.static_analysis")

-- bootstrap lazy.nvim
require("core.lazy_bootstrap")
-- setup plugins
require("lazy").setup("plugins")
