return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
  },
  config = function()
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    -- ✨ 1. Função para pegar o root atual do Neo-tree (ou o cwd)
    local function get_neotree_root()
      -- tenta obter o estado do neo-tree, mas sem depender dele estar ativo
      local ok, fs = pcall(require, 'neo-tree.sources.filesystem')
      if ok then
        local state_ok, state = pcall(fs.get_state)
        if state_ok and state and state.path and state.path ~= '' then
          return state.path
        end
      end

      -- fallback sempre válido
      return vim.loop.cwd()
    end

    -- ✨ 2. Função usada pelo Telescope para exibir paths relativos ao root
    local function relative_path_display(_, path)
      local root = get_neotree_root()
      if not root or root == '' then
        root = vim.loop.cwd()
      end

      -- usa o caminho relativo ao cwd como base
      local rel = vim.fn.fnamemodify(path, ':.')

      -- remove o prefixo do root real (neotree ou cwd)
      rel = rel:gsub('^' .. vim.pesc(root) .. '/', '')

      return rel
    end

    local function get_buffer_label(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == '' then
        return string.format('[No Name] (%d)', bufnr)
      end

      return vim.fn.fnamemodify(name, ':~:.')
    end

    local function close_buffer(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return true
      end

      if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
        local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
        if not ok then
          vim.notify(string.format('Erro ao fechar %s: %s', get_buffer_label(bufnr), err), vim.log.levels.ERROR)
        end
        return ok
      end

      local choice = vim.fn.confirm(
        string.format('O buffer %s tem alteracoes nao salvas. O que deseja fazer?', get_buffer_label(bufnr)),
        '&Salvar\n&Descartar\n&Cancelar',
        1
      )

      if choice == 0 or choice == 3 then
        return false, 'cancelled'
      end

      if choice == 1 then
        local checked, check_err = pcall(vim.api.nvim_buf_call, bufnr, function()
          vim.cmd 'silent! checktime'
        end)

        if not checked then
          vim.notify(string.format('Erro ao verificar %s: %s', get_buffer_label(bufnr), check_err), vim.log.levels.ERROR)
          return false
        end

        local saved, save_err = pcall(vim.api.nvim_buf_call, bufnr, function()
          vim.cmd 'write'
        end)

        if not saved then
          vim.notify(string.format('Erro ao salvar %s: %s', get_buffer_label(bufnr), save_err), vim.log.levels.ERROR)
          return false
        end

        local closed, close_err = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
        if not closed then
          vim.notify(string.format('Erro ao fechar %s: %s', get_buffer_label(bufnr), close_err), vim.log.levels.ERROR)
        end
        return closed
      end

      local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      if not ok then
        vim.notify(string.format('Erro ao descartar %s: %s', get_buffer_label(bufnr), err), vim.log.levels.ERROR)
      end
      return ok
    end

    local function delete_selected_buffers(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local seen = {}

      picker:delete_selection(function(entry)
        if not entry or not entry.bufnr then
          return false
        end

        if seen[entry.bufnr] then
          return true
        end
        seen[entry.bufnr] = true

        local ok, reason = close_buffer(entry.bufnr)
        if not ok and reason == 'cancelled' then
          return false
        end

        return ok
      end)
    end

    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        path_display = relative_path_display,
        mappings = {
          i = {
            ['L'] = actions.move_selection_previous,
            ['K'] = actions.move_selection_next,
            ['Ç'] = actions.select_default,
          },
          n = {
            ['L'] = actions.move_selection_previous,
            ['K'] = actions.move_selection_next,
            ['Ç'] = actions.select_default,
          },
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ['<C-x>'] = delete_selected_buffers,
            },
            n = {
              ['<C-x>'] = delete_selected_buffers,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>f', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sgg', function()
      local home = vim.fn.expand '~' -- pega a home do usuário corretamente no Windows e Linux
      require('telescope.builtin').find_files {
        prompt_title = '📘 Meu Glossário Neovim',
        search_dirs = { home .. '/AppData/Local/nvim/Glossary' },
      }
    end, { desc = '[S]earch [G]lossário' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
