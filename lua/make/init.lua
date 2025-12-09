M = {}
local proj_Type_Identifi_Mods_Dir_Path = require "make.utils.proj_Type_Identifi_Mods_Dir_Path"
local proj_Type_Identifi_Mods          = require('make.utils.proj_Type_Identifi_Mods')
local projectType                      = require('make.utils.projectType')
local constants                        = require('make.utils.constants')

function M.exec()

  local projIdentifiModsDirPath = proj_Type_Identifi_Mods_Dir_Path.get()

  local loadedProjIdentifiersMods =  proj_Type_Identifi_Mods.load(projIdentifiModsDirPath)

  local projectIdentified = projectType.run(loadedProjIdentifiersMods)
-- TEST:
  if not projectIdentified or not projectIdentified.ok then
    return
  end

  local filetype = vim.bo.filetype

  local make_root = vim.fn.stdpath("config")
  .. constants.GET.makeFolderpath
  .. filetype .. "-make/make-routines-" .. filetype .. "/"

  local routineModules = proj_Type_Identifi_Mods.load(make_root)

  for _, mod in ipairs(routineModules) do
    if mod and type(mod.setup) == "function" then
      local ok, err = pcall(mod.setup, projectIdentified)
      if not ok then
        vim.notify("Erro ao iniciar rotina de make: " .. err, vim.log.levels.ERROR)
      end
    end
  end

end

return M
