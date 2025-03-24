return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
    vim.g.snacks_animate = false
    return {
      bigfile = { endbled = true },
      dashboard = require 'custom.Snacks.dashboard',
      explorer = { replace_netrw = true },
      indent = require 'custom.Snacks.indent',
      input = { endbled = false },
      picker = require('custom.Snacks.picker').options,
      notifier = {
        timeout = 1000,
      },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = require 'custom.Snacks.status_column',
      bufferdelete = {},
      image = {},
      terminal = require 'custom.Snacks.terminal',

      animate = {},
      scope = { enabled = false },
      styles = {
        notification = {
          border = vim.g.borderStyle,
          zindex = 1000,
          ft = 'markdown',
          wo = {
            winblend = 5,
            wrap = false,
            conceallevel = 2,
            colorcolumn = '',
          },
          bo = { filetype = 'snacks_notify' },
        },
      },
    }
  end,
  keys = vim.list_extend(require('custom.Snacks.picker').keys, {
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      { desc = 'Toggle explorer' },
    },
    {
      '<F7>',
      function()
        Snacks.terminal.toggle '/usr/bin/zsh'
      end,
      mode = { 'n', 'i', 'v', 't' },
      { desc = 'Toggle Float Terminal' },
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit.open()
      end,
      { desc = 'Toggle Float lazygit' },
    },
  }),
}
