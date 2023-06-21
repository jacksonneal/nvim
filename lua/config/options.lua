local opt = vim.opt

opt.scrolloff = 6 -- keep context lines above and below cursor
opt.whichwrap:append("h,l") -- allow keys that move left/right to move to prev/next line
opt.termguicolors = true -- get true coloring
