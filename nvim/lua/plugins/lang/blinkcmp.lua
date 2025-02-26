if vim.g.cmpUsed ~= 'blink' then
  return {}
end

return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  event = 'InsertEnter',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip',
  },
  build = 'cargo build --release',
  -- use a release tag to download pre-built binaries
  version = '*',
  opts = require 'custom.Lang.blink',
}
