local config = {}

function config.telescope()
  require('telescope').setup({
    defaults = {
      prompt_prefix = ' ',
      selection_caret = ' ',
      layout_config = {
        horizontal = { prompt_position = 'top', results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require('telescope').load_extension('fzy_native')
  require('telescope').load_extension('dotfiles')
  require('telescope').load_extension('app')
end

function config.nvim_treesitter()
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'rust',
      'zig',
      'lua',
      'go',
      'python',
      'proto',
      'typescript',
      'javascript',
      'tsx',
      'bash',
      'css',
      'scss',
      'diff',
      'dockerfile',
      'gomod',
      'gosum',
      'gowork',
      'graphql',
      'html',
      'sql',
      'markdown',
      'markdown_inline',
      'json',
      'jsonc',
    },
    highlight = {
      enable = true,
      disable = function(_, buf)
        return vim.api.nvim_buf_line_count(buf) > 3000
      end,
    },
  })

  --set indent for jsx tsx
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascriptreact', 'typescriptreact' },
    callback = function(opt)
      vim.bo[opt.buf].indentexpr = 'nvim_treesitter#indent()'
    end,
  })
end

return config
