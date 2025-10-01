
local M = {}

local function run_build(cmd)
  vim.cmd("split | terminal " .. cmd)
end

M.filetype_builds = {
  ts = {
    ["a"] = { function() run_build("npm run build") end, "Build TS Project" },
  },
}

return M
