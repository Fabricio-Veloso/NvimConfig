-- plugins/dap/dap-js.lua
return {
  "mxsdev/nvim-dap-vscode-js",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local dap = require("dap")
    require("dap-vscode-js").setup({
      node_path = "node",
      adapters = { "pwa-node" },
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
    end
  end,
}
