local M = {}

-- Função para detectar sistema operacional
local function is_windows()
  return vim.loop.os_uname().version:match("Windows")
end

-- Retorna o shell correto para abrir o terminal integrado
local function get_shell()
  if is_windows() then
    return "powershell"
  else
    return "bash"
  end
end

-- Checa se o compilador Lua está disponível
local function check_lua_exists()
  if vim.fn.executable("lua") == 0 then
    vim.notify("❌ Lua não encontrado no PATH. Verifique a instalação.", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Função para abrir um split de terminal e executar um comando
local function open_term(cmd)
  local shell = get_shell()
  vim.cmd("split term://" .. shell)
  vim.cmd("startinsert") -- entra no modo terminal
  vim.fn.chansend(vim.b.terminal_job_id, cmd .. "\n")
end

-- Helper para montar comandos encadeados dependendo do SO
local function chain_commands(cmd1, cmd2)
  if is_windows() then
    -- PowerShell: executa cmd2 somente se cmd1 tiver sucesso
    return cmd1 .. "; if ($LASTEXITCODE -eq 0) { " .. cmd2 .. " }"
  else
    -- Bash: usa && como de costume
    return cmd1 .. " && " .. cmd2
  end
end

-- Função para checar sintaxe
local function check_syntax()
  if not check_lua_exists() then return end

  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("Nenhum arquivo aberto para checar.", vim.log.levels.WARN)
    return
  end

  vim.notify("🔍 Checando sintaxe de " .. file)

  local cmd = chain_commands(
    "luac -p \"" .. file .. "\"",
    is_windows() and "echo '✅ Sintaxe OK'" or "echo '✅ Sintaxe OK' || echo '❌ Erro de sintaxe'"
  )
  open_term(cmd)
end

-- Função para compilar para bytecode
local function build_bytecode()
  if not check_lua_exists() then return end

  local file = vim.fn.expand("%:p")
  local output = vim.fn.expand("%:r") .. ".luac"
  vim.notify("⚙️ Gerando bytecode: " .. output)

  local cmd = chain_commands(
    "luac -o \"" .. output .. "\" \"" .. file .. "\"",
    is_windows() and ("echo '✅ Bytecode gerado: " .. output .. "'") or ("echo '✅ Bytecode gerado: " .. output .. "'")
  )
  open_term(cmd)
end

-- Função para executar o script
local function run_script()
  if not check_lua_exists() then return end

  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("Nenhum arquivo aberto para executar.", vim.log.levels.WARN)
    return
  end

  vim.notify("🚀 Executando " .. file)
  open_term("lua \"" .. file .. "\"")
end

-- Função para build + run
local function build_and_run()
  if not check_lua_exists() then return end

  local file = vim.fn.expand("%:p")
  local output = vim.fn.expand("%:r") .. ".luac"
  vim.notify("⚙️ Gerando bytecode e executando " .. file)

  local cmd = chain_commands(
    "luac -o \"" .. output .. "\" \"" .. file .. "\"",
    "lua \"" .. output .. "\""
  )
  open_term(cmd)
end

-- Mapeamentos para o which-key
M.filetype_builds = {
  lua = {
    name = "Lua Builds",
    c = { check_syntax, "Check syntax" },
    b = { build_bytecode, "Build (gerar bytecode)" },
    r = { run_script, "Run script" },
    a = { build_and_run, "Build + Run" },
  },
}

return M
