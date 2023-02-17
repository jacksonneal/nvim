-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Escape with fast jk
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Move line up/down
keymap("v", "<C-k>", ":move '<-2<CR>gv-gv", opts)
keymap("v", "<C-j>", ":move '>+1<CR>gv-gv", opts)

-- No yank on paste
keymap("v", "p", '"_dP', opts)
