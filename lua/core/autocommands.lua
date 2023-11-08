-- Module for autocommands.

-- create an autocommand group
local group = vim.api.nvim_create_augroup("Default", {
  -- clear existing commands if the group already exists
  clear = true,
})

-- checks if buffers were changed outside of Vim and need to be reloaded
vim.api.nvim_create_autocmd({
  -- Neovim got focus
  "FocusGained",
  -- terminal job end
  "TermClose",
  -- after leaving terminal mode
  "TermLeave",
}, {
  group = group,
  command = "checktime",
})

-- highlights content on yank
vim.api.nvim_create_autocmd(
  -- after yank
  "TextYankPost",
  {
    group = group,
    callback = function()
      vim.highlight.on_yank()
    end,
  }
)

-- resizes splits if window got resized
vim.api.nvim_create_autocmd(
  -- after Vim window was resized
  "VimResized",
  {
    group = group,
    callback = function()
      -- for each tab, make windows equal
      vim.cmd("tabdo wincmd =")
    end,
  }
)

-- places cursor at last location when opening a buffer
vim.api.nvim_create_autocmd(
  -- when starting to edit a buffer
  "BufReadPost",
  {
    group = group,
    callback = function()
      -- (row, col) of last known cursor position
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      -- number of lines in buffer
      local lcount = vim.api.nvim_buf_line_count(0)
      -- if mark is valid, move to it
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  }
)

-- closes some filetypes with `q`
vim.api.nvim_create_autocmd(
  -- after 'filetype' option has been set
  "FileType",
  {
    group = group,
    -- relevant file types
    pattern = {
      "help",
      "lspinfo",
      "qf",
      "checkhealth",
    },
    callback = function(event)
      vim.keymap.set("n", "q", "<cmd>bd<cr>", {
        buffer = event.buf,
        -- non-recursive map
        noremap = true,
        -- do not echo to command line
        silent = true,
        -- execute as soon as match found, do not wait for other keys
        nowait = true,
      })
    end,
  }
)

-- wraps lines and checks spelling in text filetypes
vim.api.nvim_create_autocmd(
  -- after 'filetype' option has been set
  "FileType",
  {
    group = group,
    -- relevant file types
    pattern = { "gitcommit", "markdown" },
    callback = function()
      -- enable line wrap on display
      vim.opt_local.wrap = true
      -- enable spell checking
      vim.opt_local.spell = true
    end,
  }
)

-- auto creates dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd(
  -- before writing buffer to file
  "BufWritePre",
  {
    group = group,
    callback = function(event)
      -- make the directory
      -- :p - make filename full path
      -- :h - head is removed, leaving directory of file
      vim.fn.mkdir(vim.fn.fnamemodify(event.match, ":p:h"), "p")
    end,
  }
)
