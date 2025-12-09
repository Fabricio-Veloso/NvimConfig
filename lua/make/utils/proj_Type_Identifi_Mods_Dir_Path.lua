
--TEST:
local constants = require('make.utils.constants')

local M = {}

function M.get()
  local filetype = vim.bo.filetype
  if not filetype or filetype == "" then
    vim.notify("Filetype vazio — não é possível identificar o tipo de arquivo", vim.log.levels.WARN)
    return nil
  end

  local base = vim.fn.stdpath("config"):gsub("\\","/") .. "/lua/make/make-folders/"

  local make_root = base .. filetype .. "-make/"

  local identifiers = make_root .. "identifiers-" .. filetype .. "/"

  -- valida se a pasta existe
  if vim.fn.isdirectory(identifiers) == 0 then
    vim.notify("Nenhum identificador encontrado em: " .. identifiers, vim.log.levels.WARN)
    return nil
  end

  return identifiers
end

return M

