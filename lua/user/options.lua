local options = {
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 2,
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,
    cursorline = true,
    expandtab = true,
    fileencoding = "utf-8",
    guifont = "monospace:h17",
    hlsearch = true,
    ignorecase = true,
    linebreak = true,
    mouse = "a",
    number = true,
    numberwidth = 4,
    pumheight = 10,
    relativenumber = true,
    scrolloff = 8,
    shiftwidth = 4,
    showmode = false,
    showtabline = 2,
    sidescrolloff = 8,
    signcolumn = "yes",
    smartcase = true,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    tabstop = 4,
    termguicolors = true,
    timeoutlen = 100,
    undofile = true,
    updatetime = 300,
    wrap = true,
    writebackup = false,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.iskeyword:append "-"
vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,],h,l"

