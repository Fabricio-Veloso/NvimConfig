require 'core.options'
require 'core.keymaps'

vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

local uname = vim.loop.os_uname().sysname

if uname == 'Windows_NT' then
  local shell = nil

  -- Detecta PowerShell 7+ (pwsh) ou fallback para PowerShell 5.1
  if vim.fn.executable 'pwsh' == 1 then
    shell = 'pwsh'
  elseif vim.fn.executable 'powershell' == 1 then
    shell = 'powershell'
  else
    shell = 'cmd'
  end

  vim.o.shell = shell

  -- shellcmdflag mínimo e seguro
  vim.o.shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command'

  -- redirecionamento de saída e pipe padrão
  vim.o.shellredir = '2>&1 | Out-File %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | tee %s; exit $LastExitCode'

  -- evita problemas de aspas
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end

-- NOTE: lazy.nvim set-up
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Clipboard integration
vim.g.clipboard = {
  name = 'win32yank-wsl',
  copy = {
    ['+'] = 'win32yank.exe -i',
    ['*'] = 'win32yank.exe -i',
  },
  paste = {
    ['+'] = 'win32yank.exe -o',
    ['*'] = 'win32yank.exe -o',
  },
  cache_enabled = 0,
}
vim.opt.clipboard:prepend { 'unnamed', 'unnamedplus' }

-- Lazy.nvim plugins
require('lazy').setup {
  require 'plugins.neotree',
  require 'plugins.telescope',
  require 'plugins.nerdy',
}

-- Tema Moonfly
vim.opt.termguicolors = true
vim.cmd [[colorscheme moonfly]]

-- Automations

-- activate snipets
require('luasnip.loaders.from_vscode').lazy_load()

-- Folding com Treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldtext = 'getline(v:foldstart)'
vim.opt.fillchars = { fold = ' ' }

-- Fecha todos os folds ao abrir arquivo
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.schedule(function()
      vim.cmd 'normal! zM'
    end)
  end,
})

-- Remove opacidade do Neovim
vim.cmd [[
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
]]
