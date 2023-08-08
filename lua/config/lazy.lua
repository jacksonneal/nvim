-- File is loaded by init.lua
-- Bootstraps lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add Stardog and import its plugins
    { "jacksonneal/StardogVim", version = "0.1.*", import = "stardog.plugins" },
    -- {
    --   dir = "~/plugins/StardogVim",
    --   dev = true,
    --   import = "stardog.plugins",
    -- },
  },
  ---@diagnostic disable-next-line: assign-type-mismatch official example uses table
  dev = {
    -- dir to local plugin projects
    path = "~/plugins",
    patterns = { "StardogVim" },
    fallback = false,
  },
})
