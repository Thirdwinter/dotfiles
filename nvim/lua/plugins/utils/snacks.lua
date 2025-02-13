return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = require 'custom.Snacks.snacks_dashboard',
    input = { enabled = false },
    indent = require 'custom.Snacks.snacks_indent',
    notifier = {
      enabled = false,
    },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
    },
    scratch = {
      enabled = false,
    },
    statuscolumn = {
      enabled = true,
      left = { 'sign', 'fold' }, -- priority of signs on the left (high to low)
      right = { 'git' }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { 'GitSign', 'MiniDiffSign' },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    words = { enabled = false },
  },
  keys = {},
}
