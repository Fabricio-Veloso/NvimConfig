
local wk = require("which-key")

local M = {}

function M.setup(project)
  wk.add({
    { "<leader>m", group = "Make (Python)" },

    -- Rotinas principais
    { "<leader>mr", function() require("make.make-folders.python-make.make-routines-python.django.utils").run_server() end, desc = "Runserver" },
    { "<leader>mt", function() require("make.make-folders.python-make.make-routines-python.django.utils").run_tests() end, desc = "Testes" },
    { "<leader>mm", "<cmd>make<cr>", desc = "Rodar Makeprg" },

    -- alternativa “full pipeline”
    { "<leader>mf", function() require("make.make-folders.python-make.make-routines-python.django.utils").full() end, desc = "Full Routine" },
  })
end

return M
