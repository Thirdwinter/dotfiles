return {
  'stevearc/aerial.nvim',
  opts = function(_, opts)
    vim.keymap.set('n', '<leader>lo', '<cmd>AerialToggle!<CR>', { desc = '[S]ymblol [O]utline' })
    -- require('aerial').setup {
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    opts.layout = {
      max_width = { 40, 0.2 },
      min_width = 25,
    }
    opts.autojump = true
    opts.keymaps = {
      ['o'] = 'actions.jump',
    }
    opts.on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<F6>', '<cmd>lua require("aerial").snacks_picker()<CR>', { buffer = bufnr })
    end
    -- }
    --
  end,
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
