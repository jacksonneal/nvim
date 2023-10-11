local g = vim.g
local opt = vim.opt

local M = {}

M.setup = function()
	-- Remap leader key
	g.mapleader = " "
	g.maplocalleader = " "

	-- Fix markdown indentation settings
	g.markdown_recommended_style = 0 -- use configured tabstop

	-- Disable netrw
	g.loaded_netrw = 1
	g.loaded_netrwPlugin = 1

	opt.autowrite = true -- enable autowrite
	opt.clipboard = "unnamedplus" -- sync with system clipboard
	opt.completeopt = "menu,menuone,noselect" -- insert mode menu completion
	opt.conceallevel = 3 -- hide * markup for bold and italic
	opt.confirm = true -- confirm save changes before exiting modified buffer
	opt.colorcolumn = "-20" -- column highlight, relative to textwidth
	opt.cursorline = true -- enable highlighting of current line
	opt.expandtab = true -- use spaces instead of tabs
	opt.exrc = true -- enable local project config in .nvim.lua
	opt.formatoptions = "jcroqlnt" -- configure auto format strategy, default: tcqj
	opt.grepformat = "%f:%l:%c:%m" -- :grep output format
	opt.grepprg = "rg --vimgrep" -- use ripgrep for :grep
	opt.ignorecase = true -- ignore case in search patterns
	opt.inccommand = "nosplit" -- preview incremental substitute w/out split
	opt.laststatus = 0 -- no status line on last window
	opt.list = true -- show invisible characters
	opt.mouse = "a" -- enable mouse mode
	opt.number = true -- show line number
	opt.pumblend = 10 -- popup blend with slight transparency
	opt.pumheight = 10 -- maximum entries in a popup
	opt.relativenumber = true -- relative line numbers
	opt.scrolloff = 6 -- keep context lines above and below cursor
	opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- enable saving and restoring items
	opt.shiftround = true -- indent to multiple of shiftwidth
	opt.shiftwidth = 2 -- size of indent
	opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- shorten messages
	opt.showmode = false -- do not show mode
	opt.signcolumn = "yes:1" -- always show to avoid text shift, use 1 to avoid extra width
	opt.sidescrolloff = 8 -- columns of context
	opt.smartcase = true -- do not ignore case for capitals
	opt.smartindent = true -- smart indenting when starting a new line
	opt.spelllang = { "en" } -- english dictionary
	opt.splitbelow = true -- put new windows below current
	opt.splitkeep = "screen" -- keep text on same screen line when mananging splits
	opt.splitright = true -- put new windows right of current
	opt.tabstop = 2 -- Number of spaces tabs count for
	opt.termguicolors = true -- get true coloring
	opt.textwidth = 120 -- maximum width for text being inserted
	opt.timeoutlen = 300 -- time in ms for a mapped sequence to complete
	opt.undofile = true -- save undo history to file
	opt.undolevels = 10000 -- maximum number of changes that can be undone
	opt.updatetime = 200 -- idle typing for this time results in swap file write and trigger CursorHold
	opt.whichwrap:append("h,l") -- allow keys that move left/right to move to prev/next line
	opt.wildmode = "longest:full,full" -- command line completion mode
	opt.wrap = false -- disable line wrap
end

return M
