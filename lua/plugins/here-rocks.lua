
require('lazy').setup {
  require('plugins.dap.init.lua', {
    rocks = { hererocks = true } -- Lua 5.1 será instalada localmente pelo plugin
  }),
}
