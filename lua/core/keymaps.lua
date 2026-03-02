-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<M-s>', '<cmd> w! <CR>', opts)

-- alt + q exit's 
vim.keymap.set('n', '<M-q>', '<cmd> q <CR>', opts)


-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- navegate between splits
vim.keymap.set('n', '<C-j>', '<C-w>h', opts) -- Ir para o split à esquerda
vim.keymap.set('n', '<C-l>', '<C-w>k', opts) -- Ir para o split acima
vim.keymap.set('n', '<C-k>', '<C-w>j', opts) -- Ir para o split abaixo
vim.keymap.set('n', '<C-]>', '<C-w>l', opts) -- Ir para o split à direita

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Go from the insetmode to normal mode with jj
vim.keymap.set('i', 'kk', '<Esc>', { noremap = true, silent = true })
--vim.keymap.set('i', '<CapsLock>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-c>', ':', { noremap = true, silent = false })

-- Alt + . para o próximo buffer
vim.keymap.set('n', '<A-.>', ':bnext<CR>', { noremap = true, silent = true })

-- Alt + , para o buffer anterior
vim.keymap.set('n', '<A-,>', ':bprevious<CR>', { noremap = true, silent = true })

-- Reamps for ABNT 2 60% keyboard
vim.keymap.set('n', 'j', 'h', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'j', { noremap = true, silent = true })
vim.keymap.set('n', 'l', 'k', { noremap = true, silent = true })
vim.keymap.set('n', 'ç', 'l', { noremap = true, silent = true })

vim.keymap.set('v', 'j', 'h', { noremap = true, silent = true })
vim.keymap.set('v', 'k', 'j', { noremap = true, silent = true })
vim.keymap.set('v', 'l', 'k', { noremap = true, silent = true })
vim.keymap.set('v', 'ç', 'l', { noremap = true, silent = true })

vim.keymap.set('o', 'j', 'h', { noremap = true, silent = true })
vim.keymap.set('o', 'k', 'j', { noremap = true, silent = true })
vim.keymap.set('o', 'l', 'k', { noremap = true, silent = true })
vim.keymap.set('o', 'ç', 'l', { noremap = true, silent = true })

-- to travel to active buffer directory
vim.keymap.set('n', '<leader>f', ':Neotree reveal<CR>')

-- Fecha o buffer atual e vai para o próximo
vim.keymap.set("n", "<A-d>", function()
  -- tenta ir para o próximo buffer
  vim.cmd("bnext")
  -- fecha o anterior (que era o atual antes do bnext)
  vim.cmd("bd #")
end, { desc = "Fechar buffer atual rapidamente" })

