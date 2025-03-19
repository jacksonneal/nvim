-- Module for keymaps.

local M = {}

function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts = vim.tbl_extend("keep", opts, {
    -- non-recursive map
    noremap = true,
    -- do not echo to command line
    silent = true,
    -- execute as soon as match found, do not wait for other keys
    nowait = true,
  })
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Editor ---------------------------------------

-- Improve up/down
-- use 'g[j/k]' for display line moving only when move count is 0,
-- otherwise, use actual line numbers
M.map(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
M.map(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Better indenting
M.map("v", "<", "<gv")
M.map("v", ">", ">gv")

-- Move Lines
M.map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
M.map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
M.map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
M.map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
M.map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
M.map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Add undo break-points
M.map("i", ",", ",<c-g>u")
M.map("i", ".", ".<c-g>u")
M.map("i", ";", ";<c-g>u")

-- Avoid yank on paste
M.map("x", "p", "P")

-- File management ------------------------------

-- New file
M.map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- Save file
M.map(
  { "i", "v", "n", "s" },
  "<C-s>",
  "<cmd>w<cr><esc>",
  { desc = "Save file" }
)

-- Quit
M.map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Search ---------------------------------------

-- Clear search with <esc>
M.map(
  { "i", "n" },
  "<esc>",
  "<cmd>noh<cr><esc>",
  { desc = "Escape and clear hlsearch" }
)

-- Search word under cursor
M.map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Always search forward with n, always search backward with N,
-- regardless of starting method - / or ?
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
M.map(
  "n",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
M.map(
  "x",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
M.map(
  "o",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
M.map(
  "n",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)
M.map(
  "x",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)
M.map(
  "o",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)

-- Terminal -------------------------------------

-- Terminal management
M.map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
M.map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
M.map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
M.map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
M.map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
M.map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- Panes ----------------------------------------

-- Buffers
M.map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Window management
M.map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
M.map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
M.map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
M.map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })

-- Window navigation
M.map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
M.map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
M.map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
M.map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
M.map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
M.map(
  "n",
  "<C-Down>",
  "<cmd>resize -2<cr>",
  { desc = "Decrease window height" }
)
M.map(
  "n",
  "<C-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "Decrease window width" }
)
M.map(
  "n",
  "<C-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "Increase window width" }
)

-- Tab
M.map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
M.map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
M.map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
M.map("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next tab" })
M.map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
M.map("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- Misc -----------------------------------------

-- Lazy
M.map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

return M
