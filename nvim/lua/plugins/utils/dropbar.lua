-- if true then
--   return {}
-- end
return {
  'Bekaboo/dropbar.nvim',
  lazy = true,
  event = 'BufEnter',
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
  },
  config = function()
    require('dropbar').setup {
      -- bar = {
      --   sources = function(buf, _)
      --     local sources = require 'dropbar.sources'
      --     local filename = {
      --       get_symbols = function(buff, win, cursor)
      --         local symbols = sources.path.get_symbols(buff, win, cursor)
      --         return { symbols[#symbols] }
      --       end,
      --     }
      --     local utils = require 'dropbar.utils'
      --
      --     if vim.bo[buf].ft == 'markdown' then
      --       return {
      --         filename,
      --         sources.markdown,
      --       }
      --     end
      --     if vim.bo[buf].buftype == 'terminal' then
      --       return {
      --         sources.terminal,
      --       }
      --     end
      --     return {
      --       filename,
      --       utils.source.fallback {
      --         sources.lsp,
      --         sources.treesitter,
      --       },
      --     }
      --   end,
      -- },
    }
  end,
}
