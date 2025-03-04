if vim.g.cmpUsed ~= 'blink' then
  return {}
end

return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip',
    'neovim/nvim-lspconfig',
  },
  build = 'cargo build --release',
  version = '*',
  opts = require 'custom.Lang.blink',
}
