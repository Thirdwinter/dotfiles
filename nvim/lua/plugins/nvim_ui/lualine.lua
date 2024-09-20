-- if true then
--   return {}
-- end
local lsp_progress_config = require 'custom.Lualine.lsp_progress'
return {
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'linrongbin16/lsp-progress.nvim',
      enent = 'VimEnter',

      config = function()
        require('lsp-progress').setup(lsp_progress_config)
      end,
    },
  },

  config = function()
    require 'custom.Lualine.lualine_catppuccin'
  end,
}
