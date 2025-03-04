-- return {
--   'stevearc/resession.nvim',
--   event = 'VeryLazy',
--   opts = function()
--     local resession = require 'resession'
--     vim.keymap.set('n', '<leader>ss', resession.save, { desc = '[S]ave [Session]' })
--     vim.keymap.set('n', '<leader>sl', resession.load, { desc = '[L]oad [S]ession' })
--     vim.keymap.set('n', '<leader>sd', resession.delete, { desc = '[D]elete [S]ession' })
--     -- select a session to load
--     -- vim.keymap.set('n', '<leader>sS', '<CMD>Telescope resession<CR>', { desc = '[S]elect [S]ession' })
--   end,
-- }
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>sS", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ss", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>sd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
}
