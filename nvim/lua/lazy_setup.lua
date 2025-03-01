require('lazy').setup {
  install = { colorscheme = { 'habamax' } },
  spec = {
    { import = 'plugins.nvim_ui' },
    { import = 'plugins.utils' },
    { import = 'plugins.theme' },
    { import = 'plugins.lang' },
    -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  },
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "--since=3 days ago" }, -- show commits from the last 3 days
    timeout = 300,
  },
  checker = {
    enabled = false,
    notify = false,
  },
  ui = {
    border = vim.g.borderStyle,
    backdrop = 100,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = true, -- get a notification when changes are found
  },
}
