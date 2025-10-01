local M = {}

local function run_build(cmd)
  vim.cmd("split | terminal " .. cmd)
end

M.filetype_builds = {
  py = {
    ["a"] = { function() run_build("python -m build") end, "Build Python Project" },
  },
}

return M
