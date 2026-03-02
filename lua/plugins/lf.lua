return {
  "ptzz/lf.vim",
  dependencies = { "voldikss/vim-floaterm" },
  config = function()
    local map = vim.keymap.set

    -- Corrige o mapeamento: remove qualquer <leader>f criado pelo LF
    vim.schedule(function()
      pcall(vim.keymap.del, 'n', '<leader>f')  -- apaga o que o LF criou
      map('n', '<leader>lf', ':Neotree reveal<CR>', { desc = "Abrir Neo-tree no arquivo atual" })
    end)

    -- Mapeamento separado para abrir o LF manualmente
    map('n', '<leader>lf', ':Lf<CR>', { desc = "Abrir LF" })

    -- Configurações do LF
    vim.g.lf_netrw = 0
    vim.g.lf_preview = 1
    vim.g.lf_height = 0.85
    vim.g.lf_width = 0.85
    vim.g.lf_replace_netrw = 0
    vim.g.lf_split = "v"
    vim.g.lf_command = "lf"
    vim.g.lf_fzf = 1
    vim.g.lf_rg = 1
  end,
}
