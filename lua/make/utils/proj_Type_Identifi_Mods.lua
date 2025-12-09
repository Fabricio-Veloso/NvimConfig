-- TEST:
local M = {}

function M.load(root)
  local modules = {}

  local files = vim.fs.find(
    function(name)
      return name:match("%.lua$")
    end,
    { type = "file", path = root }
  )

  for _, file in ipairs(files) do
    local normalized = file:gsub("\\", "/")

    local lua_index = normalized:find("/lua/")
    if not lua_index then
      vim.notify("Arquivo ignorado (fora do lua/): " .. file, vim.log.levels.WARN)
      goto continue
    end

    local module_path = normalized:sub(lua_index + 5)

    local modname = module_path
    :gsub("%.lua$", "")
    :gsub("/", ".")

    local ok, mod = pcall(require, modname)

    if ok then
      table.insert(modules, mod)
    else
      vim.notify("Falha ao carregar módulo: " .. modname, vim.log.levels.ERROR)
      vim.notify(mod) -- mensagem detalhada
    end

    ::continue::
  end

  return modules
end
return M
