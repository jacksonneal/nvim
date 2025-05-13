-- Module for DAP plugins.

local function dap_set_conditional_breakpoint()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end

local function dap_set_log_breakpoint()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end

local function dap_open_debug_repl()
  require("dap").repl.open()
end

local function nvim_dap_init()
  vim.api.nvim_create_user_command(
    "DapConditionBreakpoint",
    dap_set_conditional_breakpoint,
    {}
  )
  vim.api.nvim_create_user_command(
    "DapLogBreakpoint",
    dap_set_log_breakpoint,
    {}
  )
  vim.api.nvim_create_user_command("DapReplOpen", dap_open_debug_repl, {})
end

local function dapui_toggle()
  require("dapui").toggle()
end

local function nvim_dapui_config()
  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
end

local function dapui_init()
  vim.api.nvim_create_user_command("DapuiToggle", dapui_toggle, {})
end

local function dap_python_test_method()
  require("dap-python").test_method()
end

local function nvim_dap_python_config()
  local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
  require("dap-python").setup(path)

  local python_path = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(python_path) == 1 then
    require("dap-python").resolve_python = function()
      return python_path
    end
  end

  require("dap-python").test_runner = "pytest"
end

local function nvim_dap_python_init()
  vim.api.nvim_create_user_command(
    "DapPythonTestMethod",
    dap_python_test_method,
    {}
  )
end

local plugins = {
  {
    -- DAP client
    "mfussenegger/nvim-dap",
    cmd = {
      "DapToggleBreakpoint",
      "DapTerminate",
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
    },
    keys = {
      {
        "<leader>db",
        "<cmd>DapToggleBreakpoint<cr>",
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dc",
        dap_set_conditional_breakpoint,
        desc = "Conditional breakpoint",
      },
      { "<leader>dl", dap_set_log_breakpoint,  desc = "Log breakpoint" },
      { "<leader>dr", dap_open_debug_repl,     desc = "Open REPL" },
      { "<F4>",       "<cmd>DapTerminate<cr>", desc = "Debug terminate" },
      { "<F5>",       "<cmd>DapContinue<cr>",  desc = "Debug continue" },
      { "<leader>dR", "<cmd>DapContinue<cr>",  desc = "Debug continue" },
      { "<F6>",       "<cmd>DapStepOver<cr>",  desc = "Step over" },
      { "<F7>",       "<cmd>DapStepInto<cr>",  desc = "Step into" },
      { "<F8>",       "<cmd>DapStepOut<cr>",   desc = "Step out" },
    },
    init = nvim_dap_init,
  },
  {
    -- Debug UI
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-dap",
      -- debug virtual text
      { "theHamsta/nvim-dap-virtual-text", config = true },
    },
    keys = {
      { "<F9>", dapui_toggle, "Toggle DAP UI" },
    },
    config = nvim_dapui_config,
    init = dapui_init,
  },
  {
    -- DAP Python config
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mason.nvim",
      "nvim-treesitter",
      "nvim-dap",
      "nvim-dap-ui",
    },
    keys = {
      { "<leader>dpr", dap_python_test_method, "Test method" },
    },
    config = nvim_dap_python_config,
    init = nvim_dap_python_init,
  },
  {
    -- mason and nvim-dap connect
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason.nvim",
      "nvim-dap",
    },
    opts = {
      handlers = {}
    }
  }
}

return plugins
