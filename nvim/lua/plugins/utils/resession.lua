return {
  'stevearc/resession.nvim',
  opts = function()
    local resession = require 'resession'
    vim.keymap.set('n', '<leader>ss', resession.save, { desc = '[S]ave [Session]' })
    vim.keymap.set('n', '<leader>sl', resession.load, { desc = '[L]oad [S]ession' })
    vim.keymap.set('n', '<leader>sd', resession.delete, { desc = '[D]elete [S]ession' })
    -- select a session to load
    -- vim.keymap.set('n', '<leader>sS', '<CMD>Telescope resession<CR>', { desc = '[S]elect [S]ession' })
  end,
  -- keys = {
  --   { '<leader>ss', require('resession').save, { desc = '[S]ave [Session]' } },
  --   { '<leader>sl', require('resession').load, { desc = '[L]oad [S]ession' } },
  --   { '<leader>sd', require('resession').delete, { desc = '[D]elete [S]ession' } },
  --   { '<leader>sS', '<CMD>Telescope resession<CR>', { desc = '[S]elect [S]ession' } },
  -- },
}
