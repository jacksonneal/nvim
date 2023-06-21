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
			"<leader>fE",
			function() 
				require("neo-tree.command").execute({
					toggle = true,
					dir = vim.loop.cwd()
				})
			end,
			desc = "Explorer NeoTree (cwd dir)",
		},
		{
			"<leader>e", 
			"<leader>fe",
			desc = "Explorer NeoTree (root dir)", 
			remap = true,
		},
		{
			"<leader>E", 
			"<leader>fE",
			desc = "Explorer NeoTree (cwd dir)", 
			remap = true,
		},
	},
	init = function()
		vim.g.neo_tree_remove_legacy_commands = 1
		if vim.fn.argc() == 1 then
      			local stat = vim.loop.fs_stat(vim.fn.argv(0))
      			if stat and stat.type == "directory" then
        			require("neo-tree")
      			end
		end
	end,
}
