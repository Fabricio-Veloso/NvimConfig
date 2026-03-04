return {
  -- Base LSP
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Mason: gerenciador de LSPs, linters, formatadores
    {
      "williamboman/mason.nvim",
      opts = {
        registries = {
          "github:mason-org/mason-registry", -- oficial
          "github:Crashdummyy/mason-registry", -- custom para roslyn/razor
        },
        ensure_installed = {
          "lua-language-server",
          -- "stylua",
        },
      },
    },

    -- Integração Mason + LSP
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "lua_ls", "yamlls", "html", "cssls" },
        automatic_installation = true,
      },
    },
    -- Instala ferramentas adicionais (formatadores/linters)
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = { ensure_installed = {} },
    },

    { "j-hui/fidget.nvim", opts = {} }, -- status LSP
    "hrsh7th/cmp-nvim-lsp", -- integração com completions
  },

  config = function()
    -------------------------------------------------------------------------
    -- Keymaps LSP
    -------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    -------------------------------------------------------------------------
    -- Diagnostics com ícones
    -------------------------------------------------------------------------
    if vim.g.have_nerd_font then
      local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config { signs = { text = diagnostic_signs } }
    end

    -------------------------------------------------------------------------
    -- Capabilities do nvim-cmp
    -------------------------------------------------------------------------
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    -------------------------------------------------------------------------
    -- Servidores configurados manualmente
    -------------------------------------------------------------------------
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },
      yamlls = {},
      html = {},
      cssls = {},
    }

    -------------------------------------------------------------------------
    -- Compatibilidade com Neovim 0.11+ (vim.lsp.config)
    -- e fallback para versões anteriores
    -------------------------------------------------------------------------
    local setup = vim.lsp.config or function(server, cfg)
      require("lspconfig")[server].setup(cfg)
    end

    for name, opts in pairs(servers) do
      opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
      setup(name, opts)
    end

    -------------------------------------------------------------------------
    -- Observação: Roslyn e Razor agora são carregados via plugin separado:
    -- ~/.config/nvim/lua/plugins/roslyn.lua
    -------------------------------------------------------------------------
  end,
}
