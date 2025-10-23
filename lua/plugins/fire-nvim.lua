return {
  'glacambre/firenvim',
  build = ":call firenvim#install(0)",
  config = function()
    vim.g.firenvim_config = {
      globalSettings = {
        alt = "all",  -- aplica a todos os sites
      },
      localSettings = {
        ['.*'] = {
          takeover = "always",    -- abre sempre em modo flutuante
          priority = 0,
          cmdline = "neovim",
          selector = "textarea",
          -- CSS que garante janela grande e centralizada
          css = [[
            .Firenvim {
              width: 90vw !important;
              height: 90vh !important;
              z-index: 999999 !important;
              border-radius: 8px !important;
              box-shadow: 0 0 20px rgba(0,0,0,0.4);
              background-color: var(--background, #1e1e1e) !important;
            }
            .Firenvim textarea, .Firenvim .CodeMirror-scroll {
              width: 100% !important;
              height: 100% !important;
            }
            .Firenvim .CodeMirror {
              font-size: 14pt !important;  -- aumenta a fonte para conforto
            }
          ]],
        },
      },
    }

    -- Autocomando Lua para forçar tamanho do Neovim interno
    if vim.g.started_by_firenvim then
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          vim.opt.lines = 20 -- altura interna do Neovim
          vim.opt.columns = 87 -- largura interna do Neovim
          vim.cmd("set laststatus=2")  -- barra sempre visível
          vim.cmd("set cmdheight=1")    -- linha de comando pequena
        end,
      })
    end
  end,
}
