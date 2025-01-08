-- local Terminal = require('toggleterm.terminal').Terminal
-- local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  opts = function()
    require 'custom.Toggleterm.shell'
  end,
  -- opts = {--[[ things you want to change go here]]
  -- },
}
