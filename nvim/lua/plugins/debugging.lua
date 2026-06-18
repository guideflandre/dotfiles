return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Setup Python debugging
    require("dap-python").setup("python")

    -- Open/close UI automatically
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Keybindings
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue/Start debugging" })
    vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<Leader>dO", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<Leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "Run last" })
    vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle debug UI" })
  end,
}
