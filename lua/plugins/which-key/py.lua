local M = {}

local py_cache = {
  manage_dir = nil,

}

local function run_command(cmd, dir)
  if dir then
    -- se houver virtualenv, adiciona o source antes do comando
    local source_venv = ""
    if py_cache.venv_activate then
      -- no Windows: "call path\to\activate.bat && cmd"
      if vim.loop.os_uname().sysname == "Windows_NT" then
        source_venv = 'call "' .. py_cache.venv_activate .. '" && '
      else
        -- no Linux/macOS: "source path/to/activate && cmd"
        source_venv = "source " .. py_cache.venv_activate .. " && "
      end
    end

    vim.cmd("split | terminal cd " .. dir .. " && " .. source_venv .. cmd)
  else
    vim.cmd("split | terminal " .. cmd)
  end
end

local function get_project_root()
  local cwd = vim.fn.getcwd()
  -- tenta pegar o root do git se houver
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.fn.isdirectory(git_root) == 1 then
    return git_root
  end
  return cwd
end

local function get_manage_py_dir()
  if py_cache.manage_dir and vim.fn.filereadable(py_cache.manage_dir .. "/manage.py") == 1 then
    return py_cache.manage_dir
  end

  local root = get_project_root()
  local files = vim.fn.globpath(root, "**/manage.py", false, true)
  if #files == 0 then
    return nil
  end

  local dir = vim.fn.fnamemodify(files[1], ":h")
  py_cache.manage_dir = dir
  return dir
end

local function detect_venv()
  local dir = get_project_root()
  local venv_dirs = { ".venv", "venv" }
  for _, v in ipairs(venv_dirs) do
    local activate_path
    if vim.loop.os_uname().sysname == "Windows_NT" then
      activate_path = dir .. "\\" .. v .. "\\Scripts\\Activate.ps1"
    end
    if vim.fn.filereadable(activate_path) == 1 then
      py_cache.venv_activate = activate_path
      return activate_path
    end
  end
  py_cache.venv_activate = nil
  return nil
end

local function run_django(cmd)
  local dir = get_manage_py_dir()
  if not dir then
    vim.notify("manage.py não encontrado no projeto!", vim.log.levels.ERROR)
    return
  end

  detect_venv()  -- atualiza o venv cache
  run_command(cmd, dir)
end

-- Configurações de build/commands para Python/Django
M.filetype_builds = {
  python = {
    ["a"] = { function() 
        detect_venv()
        run_command("python -m build") 
      end, "Build Python Project" 
    },
    ["m"] = { function() run_django("python manage.py migrate") end, "Apply Migrations" },
    ["r"] = { function() run_django("python manage.py runserver") end, "Run Django Server" },
    ["c"] = { function() run_django("python manage.py createsuperuser") end, "Create Superuser" },
  },
}

return M
