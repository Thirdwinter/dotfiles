return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  cmd = 'Neotree',
  config = function()
    require 'custom.neotree'
  end,
  keys = {
    { '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer', noremap = true, silent = true } },
    {
      '<leader>o',
      function()
        if vim.bo.filetype == 'neo-tree' then
          vim.cmd.wincmd 'p'
        else
          vim.cmd 'Neotree focus'
        end
      end,
      { desc = 'Toggle Explorer Focus', noremap = true, silent = true },
    },
  },
}
