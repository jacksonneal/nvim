-- Enables virtual text git blame on your current cursor line.

local M = {}

-- Run the given shell command asynchronously,
-- forwarding stdout data to the given callback.
--
---@param cmd string - to execute
---@param callback function - forward stdout data to
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

-- Namespace for current line git blame virtual text.
M.ns = vim.api.nvim_create_namespace("cur_ln_git_blame_virtual_text")

-- Extmark id.
M.extmark_id = nil

-- Hide current line git blame virtual text.
function M.hide()
  if M.extmark_id == nil then
    return
  end
  vim.api.nvim_buf_del_extmark(0, M.ns, M.extmark_id)
end

-- Show current line git blame virtual text.
function M.show()
  -- remove preexisting virtual text
  M.hide()
  -- access buffer filepath and cursor line
  local fp = vim.api.nvim_buf_get_name(0)
  local ln = vim.api.nvim_win_get_cursor(0)[1]
  -- get git blame
  run_bash_cmd_async(
    table.concat({
      "git",
      "blame",
      "--porcelain",
      fp,
      "-L",
      ln .. ",+1",
    }, " "),
    function(output)
      local vt = format(output)
      vim.schedule(function()
        -- set virtual text
        M.extmark_id = vim.api.nvim_buf_set_extmark(
          0,
          M.ns,
          ln - 1,
          0,
          { virt_text = { { vt, "Comment" } }, virt_text_pos = "right_align", hl_mode = "combine" }
        )
      end)
    end
  )
end

-- Autocommand group for current line git blame virtual text.
M.augroup = vim.api.nvim_create_augroup("cur_ln_git_blame_virtual_text", {
  clear = true,
})

-- Configure autocommands for current line virtual text for the given buffer.
function M.setup()
  -- clear preexisting autocommands
  vim.api.nvim_clear_autocmds({
    group = "cur_ln_git_blame_virtual_text",
  })

  -- hide when moving windows
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "cur_ln_git_blame_virtual_text",
    callback = M.hide,
  })

  -- show when cursor stagnates
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "cur_ln_git_blame_virtual_text",
    callback = M.show,
  })
end

return M
