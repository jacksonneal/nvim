-- Module for DAP plugins.

local function set_conditional_breakpoint()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end

local function set_log_breakpoint()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end

local function open_debug_repl()
  require("dap").repl.open()
end

local function nvim_dap_init()
  vim.api.nvim_create_user_command("DapConditionBreakpoint", set_conditional_breakpoint, {})
  vim.api.nvim_create_user_command("DapLogBreakpoint", set_log_breakpoint, {})
  vim.api.nvim_create_user_command("DapReplOpen", open_debug_repl, {})
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
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>DapBreakpointCondition<cr>", desc = "Conditional breakpoint" },
      { "<leader>dl", "<cmd>DapBreakpointLog<cr>", desc = "Log breakpoint" },
      { "<leader>dr", "<cmd>DapReplOpen<cr>", desc = "Open REPL" },
      { "<F4>", "<cmd>DapTerminate<cr>", desc = "Debug terminate" },
      { "<F5>", "<cmd>DapContinue<cr>", desc = "Debug continue" },
      { "<F6>", "<cmd>DapStepOver<cr>", desc = "Step over" },
      { "<F7>", "<cmd>DapStepInto<cr>", desc = "Step into" },
      { "<F8>", "<cmd>DapStepOut<cr>", desc = "Step out" },
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
}

return plugins
