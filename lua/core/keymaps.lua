-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set("n", "<M-s>", "<cmd> w! <CR>", opts)

-- alt + q exit's
vim.keymap.set("n", "<M-q>", "<cmd> q <CR>", opts)

-- alt + q exit's
vim.keymap.set("n", "<M-q>", "<cmd> quitall <CR>", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- navegate between splits
vim.keymap.set("n", "<C-j>", "<C-w>h", opts) -- Ir para o split à esquerda
vim.keymap.set("n", "<C-l>", "<C-w>k", opts) -- Ir para o split acima
vim.keymap.set("n", "<C-k>", "<C-w>j", opts) -- Ir para o split abaixo
vim.keymap.set("n", "<C-]>", "<C-w>l", opts) -- Ir para o split à direita

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Mapear Shift+K (ou seja, K maiúsculo) para <Esc> no modo inserção
vim.keymap.set("i", "K", "<Esc>", { noremap = true, silent = true })

--vim.keymap.set('i', '<CapsLock>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set("n", "<M-c>", ":", { noremap = true, silent = false })

-- Alt + . para o próximo buffer
vim.keymap.set("n", "<A-.>", ":bnext<CR>", { noremap = true, silent = true })

-- Alt + , para o buffer anterior
vim.keymap.set("n", "<A-,>", ":bprevious<CR>", { noremap = true, silent = true })

-- Reamps for ABNT 2 60% keyboard
vim.keymap.set("n", "j", "h", { noremap = true, silent = true })
vim.keymap.set("n", "k", "j", { noremap = true, silent = true })
vim.keymap.set("n", "l", "k", { noremap = true, silent = true })
vim.keymap.set("n", "ç", "l", { noremap = true, silent = true })

vim.keymap.set("v", "j", "h", { noremap = true, silent = true })
vim.keymap.set("v", "k", "j", { noremap = true, silent = true })
vim.keymap.set("v", "l", "k", { noremap = true, silent = true })
vim.keymap.set("v", "ç", "l", { noremap = true, silent = true })

vim.keymap.set("o", "j", "h", { noremap = true, silent = true })
vim.keymap.set("o", "k", "j", { noremap = true, silent = true })
vim.keymap.set("o", "l", "k", { noremap = true, silent = true })
vim.keymap.set("o", "ç", "l", { noremap = true, silent = true })

-- Fecha o buffer atual e vai para o próximo
vim.keymap.set("n", "<A-d>", function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })

	if #buffers > 1 then
		-- Caso com mais de um buffer
		vim.cmd("wa") -- Salva todos
		vim.cmd("bnext") -- Vai para o próximo
		vim.cmd("bd #") -- Fecha o anterior
	else
		-- Caso com apenas um buffer
		vim.cmd("wa") -- Salva alterações
		local current_buf = vim.api.nvim_get_current_buf()

		vim.cmd("enew") -- Cria um novo buffer vazio
		local new_buf = vim.api.nvim_get_current_buf()

		-- Deleta o antigo buffer
		if current_buf ~= new_buf then
			vim.api.nvim_buf_delete(current_buf, { force = true })
		end

		-- Foca no Neotree se disponível
		if pcall(vim.cmd, "Neotree reveal") then
		-- Se o Neotree estiver instalado, abre ou foca
		else
			vim.notify("Neo-tree não disponível.", vim.log.levels.INFO)
		end
	end
end, { desc = "Fechar buffer atual rapidamente" })

-- keymap para sair do modo terminal mais facilmente.
vim.keymap.set("t", "qt", [[<C-\><C-n>]], { silent = true })

--keymap to open Neogit.
vim.keymap.set("n", "<leader>g", ":Neogit<CR>", { desc = "Open Neogit" })

--keymap to open terminal.
vim.keymap.set("n", "<leader>t", ":terminal<CR>a", { desc = "Open terminal" })

--keymap para make inteligente.
vim.keymap.set("n", "<leader>mc", function()
	require("make").exec()
end, { desc = "Executar Make inteligente" })
