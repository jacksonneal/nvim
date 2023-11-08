-- configure settings
local config = require("core.config")
config.setup()

-- configure vim options
require("core.options")
-- configure keymaps
require("core.keymaps")
-- configure autocommands
require("core.autocommands")
-- configure type check
require("core.type_check")

-- bootstrap lazy.nvim
require("core.lazy_bootstrap")
-- setup plugins
require("lazy").setup("plugins")
