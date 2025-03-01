return {
  'nvimdev/lspsaga.nvim',
  event = 'VeryLazy',
  -- lazy = true,
  opts = function(_, opts)
    opts.lightbulb = {
      enable = false,
      sign = false,
      debounce = 10,
      sign_priority = 40,
      virtual_text = true,
      enable_in_insert = true,
      ignore = {
        clients = {},
        ft = {},
      },
    }
    opts.hover = {
      max_width = 0.5,
    }
    opts.ui = { border = vim.g.borderStyle, kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind() }
    -- vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
    vim.keymap.set('n', '<leader>lso', '<cmd>Lspsaga outline<CR>', { desc = '[S]ymblol [O]utline' })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
}
