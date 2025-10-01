local M = {}

local function run_build(cmd)
  vim.cmd("split | terminal " .. cmd)
end

M.filetype_builds = {
  js = {
    ["a"] = { function() run_build("npm run build") end, "Build JS Project" },
  },
}

return M
