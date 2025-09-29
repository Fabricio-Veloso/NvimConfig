return {
  "mfussenegger/nvim-dap",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local dap = require("dap")

    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe"

    local netcoredbg_adapter = {
      type = "executable",
      command = mason_path,
      args = { "--interpreter=vscode" },
    }

    dap.adapters.netcoredbg = netcoredbg_adapter
    dap.adapters.coreclr = netcoredbg_adapter

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch .NET",
        request = "launch",
        program = function()
          -- pega o diretório do arquivo atual
          local file_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")

          -- tenta achar um .csproj no diretório
          local csproj = vim.fn.glob(file_dir .. "/*.csproj")

          if csproj ~= "" then
            -- nome do projeto sem extensão
            local project_name = vim.fn.fnamemodify(csproj, ":t:r")
            local dll_path = file_dir .. "/bin/Debug/net9.0/" .. project_name .. ".dll"

            if vim.fn.filereadable(dll_path) == 1 then
              return dll_path
            end
          end

          -- fallback: sugere o bin padrão no cwd
          local fallback = vim.fn.getcwd() .. "\\bin\\Debug\\net9.0\\"
          return vim.fn.input("Path to DLL: ", fallback, "file")
        end,
      },
    }
  end,
}
