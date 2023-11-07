-- Module for DAP plugins.

local function nvim_dap_config()
  vim.api.nvim_create_user_command("DapBreakpointCondition", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, {})

  vim.api.nvim_create_user_command("DapBreakpointLog", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, {})

  vim.api.nvim_create_user_command("DapReplOpen", function()
    require("dap").repl.open()
  end, {})
end

local plugins = {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>DapBreakpointCondition<cr>", desc = "Conditional breakpoint" },
      { "<leader>dl", "<cmd>DapBreakpointLog<cr>", desc = "Log breakpoint" },
      { "<leader>dr", "<cmd>DapReplOpen<cr>", desc = "Open REPL" },
      { "<F4>", "<cmd>DapTerminate<cr>", desc = "Terminate" },
      { "<F5>", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<F6>", "<cmd>DapStepOver<cr>", desc = "Step over" },
      { "<F7>", "<cmd>DapStepInto<cr>", desc = "Step into" },
      { "<F8>", "<cmd>DapStepOut<cr>", desc = "Step out" },
    },
    config = nvim_dap_config,
  },
}

return plugins
