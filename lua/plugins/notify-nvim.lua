return{
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      background_colour = "#000000",
    })

    -- opcional: substituir o sistema de notify padrão do Neovim
    vim.notify = notify
  end
}
