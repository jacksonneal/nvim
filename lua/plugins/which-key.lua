return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		mode = { "n", "v" },
		["<leader><tab>"] = { name = "+tabs" },

	},
	config = function(_, opts) 
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}

