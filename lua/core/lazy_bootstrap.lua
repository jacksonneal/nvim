-- Module to bootstrap lazy.nvim plugin manager.

-- path to install lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- check if already present
if vim.fn.isdirectory(lazy_path) == 0 then
  -- clone lazy.nvim repo
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
end
-- add to runtime path
vim.opt.rtp:prepend(lazy_path)
