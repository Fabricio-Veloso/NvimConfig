
local M = {}
-- TEST:
function M.identify()
  local root = vim.fn.getcwd()
  local manage = vim.fn.findfile("manage.py", root .. ";")

  if manage == "" then
    return nil
  end

  return {
    ok = true,
    type = "django",
    root = root,
    main = root .. "/manage.py",
  }
end

return M
    

