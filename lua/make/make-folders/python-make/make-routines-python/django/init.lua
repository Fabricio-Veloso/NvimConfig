
local M = {}

function M.setup(project)
  -- importa submódulos
  local whichkey = require("make.make-folders.python-make.make-routines-python.django.which-key")
  local makeprg  = require("make.make-folders.python-make.make-routines-python.django.makeprg")

  whichkey.setup(project)
  makeprg.setup(project)
end

return M
