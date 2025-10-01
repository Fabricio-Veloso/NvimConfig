return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function()
    local wk = require("which-key")

    -- carrega as configs por linguagem
    local cs_builds = require("plugins.which-key.cs")
    local py_builds = require("plugins.which-key.py")
    local js_builds = require("plugins.which-key.js")
    local ts_builds = require("plugins.which-key.ts")

    -- combina todas as configurações
    local all_builds = vim.tbl_extend("force",
      cs_builds.filetype_builds or {},
      py_builds.filetype_builds or {},
      js_builds.filetype_builds or {},
      ts_builds.filetype_builds or {}
    )

    -- função para registrar keymaps de build
    local function register_build_keymaps()
      local ft = vim.bo.filetype
      local mappings = all_builds[ft]

      if mappings then
        wk.register(mappings, { prefix = "<leader>b" })
        vim.notify("Build options for filetype: " .. ft)
      else
        vim.notify("No build configured for filetype: " .. ft)
      end
    end

    -- registro principal <leader>b
    wk.register({
      ["<leader>b"] = { register_build_keymaps, "Show build options for current filetype" },
    })
  end,
}
