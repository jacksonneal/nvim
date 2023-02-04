-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Escape with fast jk
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)
