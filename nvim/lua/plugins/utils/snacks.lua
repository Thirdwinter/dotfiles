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
    -- notifier = {},
    scope = { enabled = false },
    explorer = { replace_netrw = true },
    dashboard = require 'custom.Snacks.dashboard',
    picker = require('custom.Snacks.picker').options,
    indent = require 'custom.Snacks.indent',
    statuscolumn = require 'custom.Snacks.status_column',
  },
  keys = vim.list_extend(require('custom.Snacks.picker').keys, {
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      { desc = 'Toggle explorer' },
    },
  }),
}
