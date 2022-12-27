local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	vim.notify("Installing packer, reload Neovim")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads Neovim when plugins.lua is saved
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- Use protected call to avoid error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- Top level package manager

	use("nvim-lua/popup.nvim") -- vim popup api implementation in Neovim

	use("nvim-lua/plenary.nvim") -- Lua functions

	use("numToStr/Comment.nvim") -- Comments

	use("nvim-telescope/telescope.nvim") -- find, filter, preview, pick

    -- Project management
    use("goolord/alpha-nvim") -- Greeter
    use("ahmedkhalf/project.nvim") -- Superior project management

	use("windwp/nvim-autopairs")
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")
	use("nvim-lualine/lualine.nvim")
	use("akinsho/toggleterm.nvim")
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("antoinemadec/FixCursorHold.nvim")
	use("folke/which-key.nvim")

	-- Color schemes
	use("folke/tokyonight.nvim") -- Clean and dark
	use("rose-pine/neovim") -- Natural pine, faux fur, soho vibes for classy minimalist

	-- Completion
	use("hrsh7th/nvim-cmp") -- Autocompletion
	use("hrsh7th/cmp-buffer") -- nvim-cmp source for buffer words
	use("hrsh7th/cmp-path") -- nvim-cmp source for filesystem paths
	use("hrsh7th/cmp-cmdline") -- nvim-cmp source for vim's cmdline
	use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for LSP
	use("hrsh7th/cmp-nvim-lua") -- nvim-cmp source for Lua
	use("saadparwaiz1/cmp_luasnip") -- nvim-cmp source for LuaSnip

	-- Snippets
	use("L3MON4D3/LuaSnip") -- Snippet engine for Neovim
	use("rafamadriz/friendly-snippets") -- Snippets for various languages

	-- LSP
	use("neovim/nvim-lspconfig") -- Configurations for Neovim LSP
	use("williamboman/mason.nvim") -- Package manager for LSP, DAP, linters, formatters
	use("williamboman/mason-lspconfig.nvim") -- Bridge mason.nvim with lspconfig
	use("RRethy/vim-illuminate") -- Automatic highlighting of word under cursor, next/prev occurrencekk:wq
	use("jose-elias-alvarez/null-ls.nvim") -- Inject LSP diagnostics, code actions, and more

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- Neovim tree-sitter configurations
	use("p00f/nvim-ts-rainbow") -- Rainbow parentheses using tree-sitter
	use({ "nvim-treesitter/playground", run = ":TSInstall query" }) -- Neovim tree-sitter playground

	-- Git
	use("lewis6991/gitsigns.nvim") -- Git integrations

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
