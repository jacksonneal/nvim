-- Enables virtual text git blame on your current cursor line.

local M = {}

-- Run the given shell command asynchronously,
-- calling the given callback with stdout.
--
---@param cmd string - to execute
---@param callback function - to pass stdout data
local function run_bash_cmd_async(cmd, callback)
  local uv = vim.loop

  -- construct pipes
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  -- run bash command
  local handle = uv.spawn("bash", {
    args = { "-c", cmd },
    stdio = { stdin, stdout, stderr },
  }, function(code, signal)
    if code ~= 0 then
      print("exit code", code)
      print("exit signal", signal)
    end
  end)

  -- forward stdout to callback
  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      callback(data)
    end
  end)

  -- print stderr
  uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data then
      print("stderr chunk", stderr, data)
    end
  end)

  -- close stdin and process
  uv.shutdown(stdin, function()
    uv.close(handle)
  end)
end

-- Format the given git blame for display as virtual text.
-- Expects the git blame in `--porcelain` format.
--
---@param blame string - to format
---@return string - formatted blame
local function format(blame)
  local short_sha = blame:sub(1, 7)
  local author, timestamp
  for line in blame:gmatch("[^\r\n]+") do
    if line:match("^author ") then
      author = line:match("^author (.+)$")
    elseif line:match("^author-time ") then
      timestamp = tonumber(line:match("^author-time (.+)$"))
    end
  end
  local date = os.date("%Y-%m-%d", timestamp)
  return author .. " - " .. date .. " - " .. short_sha .. " "
end

function M.git_blame(bufnr)
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = table.concat({
    "git",
    "blame",
    "--porcelain",
    buf_name,
    "-L",
    line .. ",+1",
  }, " ")
  local ns_id = vim.api.nvim_create_namespace("MyVirtualText")
  run_bash_cmd_async(cmd, function(output)
    print("output: ", output)
    local vt = format(output)
    -- Get the current buffer and window
    -- local bufnr = vim.api.nvim_get_current_buf()
    -- local winid = vim.api.nvim_get_current_win()

    -- Get the current cursor position
    -- local cursor = vim.api.nvim_win_get_cursor(0)
    -- local ln = cursor[1] - 1 -- Lua uses 0-based indexing

    -- Set the virtual text for the current line
    vim.schedule(function()
      vim.api.nvim_buf_set_extmark(
        bufnr,
        ns_id,
        line - 1,
        0,
        { virt_text = { { vt, "Comment" } }, virt_text_pos = "right_align", hl_mode = "combine" }
      )
    end)
  end)
end

M.git_blame(0)

return M
