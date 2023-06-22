-- Create a keymap.
---@param mode string | table - mode short-name
---@param lhs string - left-hand side of the mapping
---@param rhs string - right-hand side of the mapping
---@param opts table | nil - table of map arguments
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do no create keymap if a lazy key handler exists
  -- if not keys.active[keys.parse({ lhs, mode = mode }).id] then
  opts = opts or {}
  opts.silent = opts.silent ~= false
  if opts.remap and not vim.g.vscode then
    opts.remape = nil
  end
  vim.keymap.set(mode, lhs, rhs, opts)
  -- end
end

-- Remap leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Improve up/down
-- use 'g[j/k]' for display line moving only when move count is 0
map(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
map(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map(
  "n",
  "<C-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "Decrease window width" }
)
map(
  "n",
  "<C-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "Increase window width" }
)

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Move between buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
map(
  { "i", "n" },
  "<esc>",
  "<cmd>noh<cr><esc>",
  { desc = "Escape and clear hlsearch" }
)

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
