
local M = {}

-- guarda o id do job do terminal atual
local current_term = nil

--------------------------------------------------------
-- Abre um split com terminal e armazena o job id
--------------------------------------------------------
function M.open_split(opts)
  opts = opts or {}
  local direction = opts.direction or "horizontal"
  local size = opts.size or 15

  if direction == "vertical" then
    vim.cmd(size .. "vsplit")
  else
    vim.cmd(size .. "split")
  end

  vim.cmd("terminal")

  -- pega o job id do terminal aberto
  local buf = vim.api.nvim_get_current_buf()
  current_term = vim.b[buf].terminal_job_id

  if not current_term then
    vim.notify("Não foi possível abrir terminal.", vim.log.levels.ERROR)
  end
end

--------------------------------------------------------
-- Envia texto para o terminal atual
--------------------------------------------------------
function M.send(cmd)
  if not current_term then
    vim.notify("Nenhum terminal aberto para enviar comandos.", vim.log.levels.WARN)
    return
  end

  -- vim.fn.chansend envia direto para o job
  vim.fn.chansend(current_term, cmd .. "\n")
end

--------------------------------------------------------
-- Abre terminal se não houver
--------------------------------------------------------
function M.ensure_term()
  if not current_term then
    M.open_split()
  end
end

--------------------------------------------------------
-- Abre terminal e já envia comandos
--------------------------------------------------------
function M.run_in_terminal(cmd)
  M.ensure_term()
  M.send(cmd)
end

--------------------------------------------------------
-- Fecha o terminal atual (opcional)
--------------------------------------------------------
function M.close()
  if not current_term then
    return
  end

  -- Descobrir qual janela tem o terminal
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].terminal_job_id == current_term then
      vim.api.nvim_win_close(win, true)
      current_term = nil
      return
    end
  end
end

return M
