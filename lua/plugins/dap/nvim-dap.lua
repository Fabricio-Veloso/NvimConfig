return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest",
    "Issafalcon/neotest-dotnet",
  },
  config = function()
    local dap = require("dap")

    -- Aqui você coloca só as configs globais do dap
    -- (ex: adapters, configurações básicas, etc.)
  end,
}
