return {

  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function()
    -- silencia mensagens do which-key
    local orig_notify = vim.notify
    vim.notify = function(msg, level, opts)
      if type(msg) == "string" and msg:match("which%-key") then
        return
      end
      orig_notify(msg, level, opts)
    end

    local wk = require("which-key")

    -- carrega as configs por linguagem
    local cs_builds = require("plugins.which-key.cs")
    local py_builds = require("plugins.which-key.py")
    local js_builds = require("plugins.which-key.js")
    local ts_builds = require("plugins.which-key.ts")

    -- combina todas as configurações (merge profundo)
    local all_builds = vim.tbl_deep_extend("force",
      cs_builds.filetype_builds or {},
      py_builds.filetype_builds or {},
      js_builds.filetype_builds or {},
      ts_builds.filetype_builds or {}
    )

    -- tabela para evitar registrar múltiplas vezes
    local registered = {}

    -- registra builds quando um buffer com filetype válido for aberto
    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.tbl_keys(all_builds),
      callback = function(args)
        local ft = args.match
        if registered[ft] then return end


        local mappings = all_builds[ft]
        wk.register(mappings, { prefix = "<leader>b" })
        registered[ft] = true
        vim.notify("Build options registered for filetype: " .. ft)
      end
    })

    -- registro genérico <leader>b (mostra os builds atuais do buffer)
    wk.register({
      ["<leader>b"] = { function()
        local ft = vim.bo.filetype
        local mappings = all_builds[ft]
        if mappings then
          wk.show(mappings, { prefix = "<leader>b" })
        else
          vim.notify("No build configured for filetype: " .. ft)
        end
      end, "Show build options for current filetype" },
    })
  end,
}
