local opt = vim.opt

opt.cursorline = true -- enable highlighting of current line
opt.number = true -- show line number
opt.relativenumber = true -- relative line numbers
opt.scrolloff = 6 -- keep context lines above and below cursor
opt.shiftwidth = 4 -- size of indent
opt.splitbelow = true -- put new windows below current
opt.splitright = true -- put new windows right of current
opt.termguicolors = true -- get true coloring
opt.whichwrap:append("h,l") -- allow keys that move left/right to move to prev/next line
