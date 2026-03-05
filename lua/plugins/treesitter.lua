return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = { 'bash', 'html', 'markdown', 'markdown_inline', 'vim', 'vimdoc' }, -- sem lua nem c_sharp
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'html' },
    },
    indent = { enable = true, disable = { 'html' } },
  },
}
