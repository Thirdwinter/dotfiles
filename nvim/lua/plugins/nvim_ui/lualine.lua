-- if true then
--   return {}
-- end
local lsp_progress_config = require 'custom.Lualine.lsp_progress'
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'linrongbin16/lsp-progress.nvim',
      event = 'VimEnter',

      config = function()
        require('lsp-progress').setup(lsp_progress_config)
      end,
    },
  },

  config = function()
    require 'custom.Lualine.lualine'
  end,
}
