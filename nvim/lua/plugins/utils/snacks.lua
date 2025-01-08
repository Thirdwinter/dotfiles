return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    input = { enabled = false },
    indent = require 'custom.Snacks.snacks_indent',
    notifier = {
      enabled = false,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
    },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    styles = {
      -- notification = {
      --   -- wo = { wrap = true } -- Wrap notifications
      -- }
    },
  },
  keys = {},
}
