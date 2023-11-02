local buffer = require("util.buffer")
local shell = require("util.shell")

local api = vim.api

local function format_lua()
  local filepath = buffer.filepath()
  shell.call({ "stylua", filepath })
end

local function format()
  api.nvim_command("w")

  local file_type = buffer.file_type()
  if file_type == "lua" then
    format_lua()
  else
    vim.notify("No formatter available for " .. file_type)
  end

  api.nvim_command("edit!")
end

vim.keymap.set("n", "<leader>f", format)

local type_check_buffer = nil
local function type_check_python()
  local filepath = vim.api.nvim_buf_get_name(0)

  if type_check_buffer == nil then
    api.nvim_command("vnew")
    type_check_buffer = api.nvim_get_current_buf()
  else
    api.nvim_set_current_buf(type_check_buffer)
  end

  api.nvim_command("terminal pre-commit run mypy --file " .. filepath)
end

local function type_check()
  local file_type = buffer.file_type()
  if file_type == "python" then
    type_check_python()
  else
    vim.notify("No type checker available for " .. file_type)
  end
end

vim.keymap.set("n", "<leader>t", type_check)

local buffer_number = -1

local function log(_, data)
  if data then
    -- Make it temporarily writable so we don't have warnings.
    vim.api.nvim_buf_set_option(buffer_number, "readonly", false)

    -- Append the data.
    vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, data)

    -- Make readonly again.
    vim.api.nvim_buf_set_option(buffer_number, "readonly", true)

    -- Mark as not modified, otherwise you'll get an error when
    -- attempting to exit vim.
    vim.api.nvim_buf_set_option(buffer_number, "modified", false)

    -- Get the window the buffer is in and set the cursor position to the bottom.
    local buffer_window = vim.api.nvim_call_function("bufwinid", { buffer_number })
    local buffer_line_count = vim.api.nvim_buf_line_count(buffer_number)
    vim.api.nvim_win_set_cursor(buffer_window, { buffer_line_count, 0 })
  end
end

local function open_buffer()
  -- Get a boolean that tells us if the buffer number is visible anymore.
  --
  -- :help bufwinnr
  local buffer_visible = vim.api.nvim_call_function("bufwinnr", { buffer_number }) ~= -1

  if buffer_number == -1 or not buffer_visible then
    -- Create a new buffer with the name "AUTOTEST_OUTPUT".
    -- Same name will reuse the current buffer.
    vim.api.nvim_command("botright vsplit AUTOTEST_OUTPUT")

    -- Collect the buffer's number.
    buffer_number = vim.api.nvim_get_current_buf()

    -- Mark the buffer as readonly.
    vim.opt_local.readonly = true
  end
end

local function autotest(pattern, command)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = pattern,
    callback = function()
      local buffer_name = vim.api.nvim_buf_get_name(0)

      -- Open our buffer, if we need to.
      open_buffer()

      -- Clear the buffer's contents incase it has been used.
      vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, {})

      -- Run the command.
      vim.fn.jobstart(command .. " " .. buffer_name, {
        stdout_buffered = true,
        on_stdout = log,
        on_stderr = log,
      })
    end,
  })
end

autotest("*.py", ". ./venv/bin/activate && mypy")
