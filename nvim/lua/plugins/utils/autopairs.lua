return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup { map_cr = true }
  end,
  -- use opts = {} for passing setup options
  -- this is equivalent to setup({}) function
}
