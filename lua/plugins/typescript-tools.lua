return {
  'pmizio/typescript-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
  },
  opts = {
    on_attach = function(client, bufnr)
      -- seu código de attach aqui, se tiver
    end,
    settings = {
      separate_diagnostic_server = false,
      publish_diagnostic_on = 'insert_leave',
      expose_as_code_action = { 'all' },
      tsserver_locale = 'en',
      code_lens = 'off',
      jsx_close_tag = {
        enable = false,
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeCompletionsForModuleExports = true,
        quotePreference = 'auto',
      },
      tsserver_format_options = {
        allowIncompleteCompletions = false,
        allowRenameOfImportPath = false,
      },
    },
  },
}
