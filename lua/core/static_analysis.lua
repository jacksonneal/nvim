-- manage the buffer number that will hold static analysis output
local bufnr = -1

-- log data to the buffer
local function log(_, data)
  if not data then
    return
  end

  -- make buffer writable
  vim.api.nvim_buf_set_option(bufnr, "readonly", false)

  -- append data to buffer
  vim.api.nvim_buf_set_lines(bufnr, -1, -1, true, data)

  -- make buffer readonly
  vim.api.nvim_buf_set_option(bufnr, "readonly", true)

  -- mark buffer as not modified
  vim.api.nvim_buf_set_option(bufnr, "modified", false)
end

-- open the buffer
local function open_buffer()
  -- determine if the buffer is visible (has a window)
  local buffer_visible = vim.api.nvim_call_function("bufwinnr", { bufnr }) ~= -1

  -- if buffer exists and is visible, do nothing
  if bufnr ~= -1 and buffer_visible then
    return
  end

  -- create a buffer to use for static analysis output
  vim.api.nvim_command("botright vsplit STATIC_ANALYSIS_OUTPUT")

  -- access the buffer number
  bufnr = vim.api.nvim_get_current_buf()

  -- mark the buffer as readonly.
  vim.opt_local.readonly = true
end

-- clear the buffer
local function clear_buffer()
  -- if buffer does not exist, return
  if bufnr == -1 then
    return
  end

  -- make buffer writable
  vim.api.nvim_buf_set_option(bufnr, "readonly", false)

  -- clear the buffer contents
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, {})

  -- mark buffer as not modified
  vim.api.nvim_buf_set_option(bufnr, "modified", false)
end

local function make_static_analyze_with_output(name, command)
  vim.api.nvim_create_user_command(name, function()
    -- access buffer name to analyze
    local buffer_name = vim.api.nvim_buf_get_name(0)

    -- open output buffer
    open_buffer()

    -- clear the buffer contents
    clear_buffer()

    -- execute command on buffer
    vim.fn.jobstart(command .. " " .. buffer_name, {
      stdout_buffered = true,
      on_stdout = log,
      on_stderr = log,
    })
  end, {})
end

local function make_static_analyze_fix(name, command)
  vim.api.nvim_create_user_command(name, function()
    -- save current buffer
    vim.api.nvim_command("w")

    -- access buffer name to analyze
    local buffer_name = vim.api.nvim_buf_get_name(0)

    -- execute command on buffer
    vim.fn.jobstart(command .. " " .. buffer_name, {
      stdout_buffered = true,
      on_exit = function()
        -- load buffer changes
        vim.api.nvim_command("edit!")
      end,
    })
  end, {})
end

local group = vim.api.nvim_create_augroup("StaticAnalysis", {
  -- clear existing commands if the group already exists
  clear = true,
})

-- make StyLua command
make_static_analyze_fix("StyLua", "stylua")
-- format lua files
vim.api.nvim_create_autocmd(
  -- after 'filetype' option has been set
  "FileType",
  {
    group = group,
    -- relevant file types
    pattern = {
      "lua",
    },
    callback = function(event)
      vim.keymap.set("n", "<leader>Q", "<cmd>StyLua<cr>", {
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

-- make Mypy command
make_static_analyze_with_output("Mypy", ". ./venv/bin/activate && mypy")
-- type check python files
vim.api.nvim_create_autocmd(
  -- after 'filetype' option has been set
  "FileType",
  {
    group = group,
    -- relevant file types
    pattern = {
      "python",
    },
    callback = function(event)
      vim.keymap.set("n", "<leader>t", "<cmd>Mypy<cr>", {
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
