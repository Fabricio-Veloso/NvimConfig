local M = {}

function M.setup(project)
  -- Exemplo: definindo makeprg de acordo com o projeto detectado
  vim.opt.makeprg = "pytest"

  -- Se quiser: registrar um comando extra
  vim.api.nvim_create_user_command("PyRunserver", function()
    require("make.make-folders.python-make.make-routines-python.utils").run_server()
  end, {})
end

return M
