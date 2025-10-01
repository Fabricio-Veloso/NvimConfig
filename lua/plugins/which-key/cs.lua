local M = {}

-- cache para entry point
local dotnet_cache = {}

-- Função para abrir terminal e executar comando
local function run_command(cmd, dir)
  if dir then
    vim.cmd("split | terminal cd " .. dir .. " && " .. cmd)
  else
    vim.cmd("split | terminal " .. cmd)
  end
end

-- Função para listar arquivos por padrão
local function list_files(root_dir, pattern)
  return vim.fn.globpath(root_dir, "**/" .. pattern, false, true)
end

-- Função para selecionar arquivo dentre várias opções
local function select_file(files, prompt)
  if #files == 0 then return nil end
  if #files == 1 then return files[1] end
  local choice
  vim.ui.select(files, { prompt = prompt }, function(item)
    choice = item
  end)
  vim.wait(1000, function() return choice ~= nil end)
  return choice
end

-- Função para escolher entry point: .sln → .csproj → Program.cs
local function select_entry_point(root_dir)
  local file

  -- 1️⃣ Procura .sln
  local sln_files = list_files(root_dir, "*.sln")
  file = select_file(sln_files, "Escolha a solução (.sln):")
  if file then return file end

  -- 2️⃣ Procura .csproj
  local csproj_files = list_files(root_dir, "*.csproj")
  file = select_file(csproj_files, "Escolha o projeto (.csproj):")
  if file then return file end

  -- 3️⃣ Procura Program.cs como fallback
  local program_files = list_files(root_dir, "Program.cs")
  file = select_file(program_files, "Escolha o arquivo Program.cs:")
  if file then return file end

  vim.notify("Nenhuma solução, projeto ou Program.cs encontrada!", vim.log.levels.ERROR)
  return nil
end

-- Função principal de build
local function dotnet_build(version)
  local root_dir = vim.fn.getcwd()
  local file

  if dotnet_cache["cs"] then
    local cached_dir = vim.fn.fnamemodify(dotnet_cache["cs"], ":h")
    if cached_dir ~= root_dir then
      dotnet_cache["cs"] = nil
    end
  end

  if dotnet_cache["cs"] and vim.fn.filereadable(dotnet_cache["cs"]) == 1 then
    file = dotnet_cache["cs"]
  else
    file = select_entry_point(root_dir)
    if file then
      dotnet_cache["cs"] = file
    else
      return
    end
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  local ext = vim.fn.fnamemodify(file, ":e")
  local cmd

  if ext == "cs" then
    cmd = "dotnet run --project " .. dir
  elseif version == "msbuild" then
    cmd = 'msbuild "' .. file .. '" /t:Build'
  else
    cmd = 'dotnet build "' .. file .. '"'
  end

  run_command(cmd, dir)
  vim.notify("Executando build: " .. file)
end

-- Função para run (dotnet run)
local function dotnet_run()
  local root_dir = vim.fn.getcwd()
  local file = dotnet_cache["cs"] or select_entry_point(root_dir)
  if not file then return end
  dotnet_cache["cs"] = file

  local dir = vim.fn.fnamemodify(file, ":h")
  run_command("dotnet run --project " .. dir, dir)
  vim.notify("Executando dotnet run: " .. file)
end

-- Função para watch (dotnet watch run)
local function dotnet_watch()
  local root_dir = vim.fn.getcwd()
  local file = dotnet_cache["cs"] or select_entry_point(root_dir)
  if not file then return end
  dotnet_cache["cs"] = file

  local dir = vim.fn.fnamemodify(file, ":h")
  run_command("dotnet watch run --project " .. dir, dir)
  vim.notify("Executando dotnet watch run: " .. file)
end

-- Função para clean (dotnet clean)
local function dotnet_clean()
  local root_dir = vim.fn.getcwd()
  local file = dotnet_cache["cs"] or select_entry_point(root_dir)
  if not file then return end
  dotnet_cache["cs"] = file

  local dir = vim.fn.fnamemodify(file, ":h")
  run_command("dotnet clean --project " .. dir, dir)
  vim.notify("Executando dotnet clean: " .. file)
end

-- Configurações de build/commands para C#
M.filetype_builds = {
  cs = {
    ["a"] = { function() dotnet_build("msbuild") end, "Build .NET 4.8 (MSBuild)" },
    ["b"] = { function() dotnet_build("dotnet") end, "Build .NET 9 (dotnet CLI)" },
    ["r"] = { dotnet_run, "Run .NET Project" },
    ["w"] = { dotnet_watch, "Watch & Run .NET Project" },
    ["c"] = { dotnet_clean, "Clean .NET Project" },
  },
}

return M
