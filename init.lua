require 'core.options'
require 'core.keymaps'

vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

local uname = vim.loop.os_uname().sysname

