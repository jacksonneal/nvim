local opt = vim.opt

opt.cursorline = true -- enable highlighting of current line
opt.number = true -- show line number
opt.relativenumber = true -- relative line numbers
opt.scrolloff = 6 -- keep context lines above and below cursor
opt.shiftwidth = 4 -- size of indent
opt.termguicolors = true -- get true coloring
opt.whichwrap:append("h,l") -- allow keys that move left/right to move to prev/next line
