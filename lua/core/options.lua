-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- remap leader key, available for use as `<leader>` in global mappings
vim.g.mapleader = " "
-- same as 'mapleader', for local buffer mappings
vim.g.maplocalleader = " "
-- fix markdown indentation settings, use configured 'tabstop'
vim.g.markdown_recommended_style = 0

-- enable autowrite on file modification
vim.opt.autowrite = true
-- adjust default color groups for background (used by colorscheme)
vim.opt.background = "light"
-- sync copy content to system clipboard
vim.opt.clipboard = "unnamedplus"
-- 'Insert' mode completion menu settings
-- menu - use popup menu
-- menuone - use menu even if only one match
-- noselect - do not auto-select an item in the menu
vim.opt.completeopt = "menu,menuone,noselect"
-- hide text with "conceal" attribute (e.g. `*` markup for bold and italic)
vim.opt.conceallevel = 3
-- confirm changes for operations that would normally fail on unsaved changed (e.g. `:q`)
vim.opt.confirm = true
-- column highlight, relative to 'textwidth'
vim.opt.colorcolumn = "-20"
-- enable highlight of current line
vim.opt.cursorline = true
-- expand spaces to tabs
vim.opt.expandtab = true
-- enable local project config in .nvim.lua
vim.opt.exrc = true
-- auto format options
-- t - wrap text using 'textwidth'
-- c - wrap comments using 'textwidth'
-- r - insert comment leader after hitting `<Enter>` in 'Insert' mode
-- o - insert comment leader after hitting `o` or `O` in 'Normal' mode
-- l - long lines are not broken in insert mode
-- j - remove comment leader when joining lines
vim.opt.formatoptions = "tcrolj"
-- :grep output format - file:line:column:match
vim.opt.grepformat = "%f:%l:%c:%m"
-- use ripgrep for :grep
vim.opt.grepprg = "rg --vimgrep"
-- ignore case in search patterns
vim.opt.ignorecase = true
-- preview incremental substitute w/out split
vim.opt.inccommand = "nosplit"
-- no status line on last window
vim.opt.laststatus = 0
-- show invisible characters (e.g. tabs as '>', trailing space as '-')
vim.opt.list = true
-- enable mouse mode
vim.opt.mouse = "a"
-- show line numbers
vim.opt.number = true
-- popup menu with slight transparency
vim.opt.pumblend = 15
-- maximum entries in a popup
vim.opt.pumheight = 10
-- show/hide relative line numbers
vim.opt.relativenumber = false
-- keep context lines above and below cursor
vim.opt.scrolloff = 6
-- enable saving and restoring items using sessions
vim.opt.sessionoptions = {
  -- buffers, including hidden
  "buffers",
  -- current directory
  "curdir",
  -- tabs
  "tabpages",
  -- window sizes
  "winsize",
}
-- indent to multiple of 'shiftwidth' with `>` and `<`
vim.opt.shiftround = true
-- size of indent in spaces
vim.opt.shiftwidth = 2
-- shorten messages
vim.opt.shortmess:append({
  -- when writing file
  W = true,
  -- when starting vim
  I = true,
  -- completion
  c = true,
  C = true,
})
-- do not show mode
vim.opt.showmode = false
-- always show to avoid text shift, use 1 for diagnostics
vim.opt.signcolumn = "yes:1"
-- keep context lines to right and left of cursor
vim.opt.sidescrolloff = 6
-- do not ignore case for capitals in search
vim.opt.smartcase = true
-- smart indenting when starting a new line
vim.opt.smartindent = true
-- disable spell checking
vim.opt.spell = false
-- use English dictionary for spell checking
vim.opt.spelllang = { "en" }
-- put new windows below current
vim.opt.splitbelow = true
-- keep text on same screen line when managing splits
vim.opt.splitkeep = "screen"
-- put new windows right of current
vim.opt.splitright = true
-- number of spaces tabs count for
vim.opt.tabstop = 2
-- get 24-bit RGB coloring
vim.opt.termguicolors = true
-- maximum width for text in 'Insert' mode
vim.opt.textwidth = 120
-- time in ms for a mapped sequence to complete
vim.opt.timeoutlen = 350
-- save undo history to file
vim.opt.undofile = true
-- maximum number of changes that can be undone
vim.opt.undolevels = 10000
-- idle typing for this time results in swap file write and trigger 'CursorHold' event
vim.opt.updatetime = 200
-- allow move left/right to move to prev/next line
vim.opt.whichwrap:append("h,l")
-- command line completion mode
vim.opt.wildmode = "longest:full,full"
-- disable line wrap on display
vim.opt.wrap = false
