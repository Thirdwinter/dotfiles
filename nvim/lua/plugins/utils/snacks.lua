return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {},
    animate = { enabled = false },
    bufferdelete = {},
    image = {},
    quickfile = {},
    scroll = { enabled = false },
    terminal = require 'custom.Snacks.terminal',
    notifier = {},
    -- notifier = {},
    scope = { enabled = false },
    explorer = { replace_netrw = true },
    dashboard = require 'custom.Snacks.dashboard',
    picker = require('custom.Snacks.picker').options,
    indent = require 'custom.Snacks.indent',
    statuscolumn = require 'custom.Snacks.status_column',
    styles = {
      notification = {
        border = vim.g.borderStyle,
        zindex = 100,
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
  },
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
