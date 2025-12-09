
local terminal = require("make.utils.terminal")

local M = {}

-- Abre terminal + ativa venv + roda coisas dentro
local function open_term_and(cmd)
  terminal.open_split()
  terminal.send("./venv\\Scripts\\Activate.ps1")
  terminal.send(cmd)
end

function M.run_server()
  open_term_and("python manage.py runserver")
end

function M.run_tests()
  open_term_and("python pytest")
end

function M.full()
  open_term_and("./venv\\Scripts\\Activate.ps1 && python pytest && python manage.py runserver")
end

return M
