return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	branch = "v2.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			window = {
				width = 30,
				mappings = {
					["h"] = "close_node",
					["l"] = "open",
					["v"] = "open_vsplit",
				},
			},
		},
	},
	keys = {
		{
			"<leader>fe",
			function() 
				require("neo-tree.command").execute({
					toggle = true,
				})
			end,
			desc = "Explorer NeoTree (root dir)",
		},
		{
			"<leader>e", 
			"<leader>fe",
			"Explorer NeoTree (root dir)", 
			remap = true,
		},
	},

}
