-- Module for type checking.

local group = vim.api.nvim_create_augroup("TypeCheck", {})

local mypy_command = "<cmd>2TermExec cmd='. ./venv/bin/activate && mypy .'<cr>"
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "python",
  },
  callback = function(event)
    vim.keymap.set("n", "<leader>t", mypy_command, { buffer = event.buf })
  end,
})
