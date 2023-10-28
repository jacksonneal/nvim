-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- remap leader key, available for use as `<leader>` in global mappings
vim.g.mapleader = " "
-- same as mapleader, for local buffer mappings
vim.g.maplocalleader = " "
-- fix markdown indentation settings, use configured tabstop
vim.g.markdown_recommended_style = 0

-- enable autowrite on file modification
vim.opt.autowrite = true
-- sync copy content to system clipboard
vim.opt.clipboard = "unnamedplus"
-- insert mode completion menu settings
vim.opt.completeopt = "menu,menuone,noselect"
-- hide text with "conceal" attribute (e.g. `*` markup for bold and italic)
vim.opt.conceallevel = 3
-- confirm changes for operations that would normally fail on unsaved changed (e.g. `:q`)
vim.opt.confirm = true
-- column highlight, relative to textwidth
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
-- popup blend with slight transparency
vim.opt.pumblend = 15
-- maximum entries in a popup
vim.opt.pumheight = 10
-- show relative line numbers
vim.opt.relativenumber = true
-- keep context lines above and below cursor
vim.opt.scrolloff = 6
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- enable saving and restoring items
vim.opt.shiftround = true -- indent to multiple of shiftwidth
vim.opt.shiftwidth = 2 -- size of indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- shorten messages
vim.opt.showmode = false -- do not show mode
vim.opt.signcolumn = "yes:1" -- always show to avoid text shift, use 1 to avoid extra width
vim.opt.sidescrolloff = 8 -- columns of context
vim.opt.smartcase = true -- do not ignore case for capitals
vim.opt.smartindent = true -- smart indenting when starting a new line
vim.opt.spelllang = { "en" } -- english dictionary
vim.opt.splitbelow = true -- put new windows below current
vim.opt.splitkeep = "screen" -- keep text on same screen line when mananging splits
vim.opt.splitright = true -- put new windows right of current
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- get true coloring
vim.opt.textwidth = 120 -- maximum width for text being inserted
vim.opt.timeoutlen = 300 -- time in ms for a mapped sequence to complete
vim.opt.undofile = true -- save undo history to file
vim.opt.undolevels = 10000 -- maximum number of changes that can be undone
vim.opt.updatetime = 200 -- idle typing for this time results in swap file write and trigger CursorHold
vim.opt.whichwrap:append("h,l") -- allow keys that move left/right to move to prev/next line
vim.opt.wildmode = "longest:full,full" -- command line completion mode
vim.opt.wrap = false -- disable line wrap
