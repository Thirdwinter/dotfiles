require('lazy').setup {
  spec = {
    { import = 'plugins.nvim_ui' },
    { import = 'plugins.utils' },
    { import = 'plugins.theme' },
    { import = 'plugins.lang' },
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  },
  checker = {
    enabled = true,
    notify = true,
  },
  ui = {
    border = 'none',
    backdrop = 60,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = true, -- get a notification when changes are found
  },
}
