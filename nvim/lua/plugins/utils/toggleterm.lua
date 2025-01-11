-- local Terminal = require('toggleterm.terminal').Terminal
-- local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  opts = function()
    require 'custom.Toggleterm.shell'
  end,
  keys = {
    { '<F7>', 't', '<Cmd>ToggleTerm<CR>', { desc = 'ToggleTerm float' } },
    { '<Esc><Esc>', 't', '<C-\\><C-n>', { desc = '退出终端模式' } },
  },
  -- opts = {--[[ things you want to change go here]]
  -- },
}
