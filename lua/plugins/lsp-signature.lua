return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  config = function()
    require("lsp_signature").setup({
      bind = true,
      floating_window = true,
      floating_window_above_cur_line = true,
      hint_enable = true,
      hint_prefix = "🦉 ",
      hint_scheme = "String",
      wrap = true,
      always_trigger = false,
      extra_trigger_chars = { "<", "(", "," },
      toggle_key = '<C-x>',  
      -- o toggle key para ver mais linhas é Crtl s
      -- 🔹 parâmetros estáveis
      doc_lines = 0,       -- número fixo de linhas de doc
      max_height = 1,     -- altura máxima da janela
      max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.9), -- largura proporcional à janela

      handler_opts = {
        border = "rounded",
        zindex = 50,
      },
      padding = " ",
      transparency = 10,
      shadow_blend = 20,
      shadow_guibg = "#1e1e2e",
      hi_parameter = "LspSignatureActiveParameter",
    })

  end,
}
