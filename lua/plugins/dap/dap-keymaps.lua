return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
    { "<F8>", function() require("dap").step_out() end, desc = "DAP Step Out" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP Open REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "DAP Run Last" },
  },
}
