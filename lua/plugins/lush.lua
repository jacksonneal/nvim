return {
	{
		"rktjmp/lush.nvim", 
	},
	{ dir = "~/themes/stardog", lazy = false, priority = 1000, 
		config = function ()
			vim.cmd([[colorscheme stardog]])
		end,
	},
}
