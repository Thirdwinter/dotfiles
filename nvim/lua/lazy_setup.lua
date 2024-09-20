require('lazy').setup({
  -- { import = "plugins" },
  { import = 'plugins.nvim_ui' },
  { import = 'plugins.utils' },
  { import = 'plugins.theme' },
  { import = 'plugins.lang' },
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    -- 	icons = vim.g.have_nerd_font and {} or {
    -- 		cmd = '⌘',
    -- 		config = '🛠',
    -- 		event = '📅',
    -- 		ft = '📂',
    -- 		init = '⚙',
    -- 		keys = '🗝',
    -- 		plugin = '🔌',
    -- 		runtime = '💻',
    -- 		require = '🌙',
    -- 		source = '📄',
    -- 		start = '🚀',
    -- 		task = '📌',
    -- 		lazy = '💤 ',
    -- 	},
  },
})
