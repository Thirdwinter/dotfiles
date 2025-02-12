if true then
  return {}
end
return {
  'OXY2DEV/markview.nvim',
  lazy = false, -- Recommended
  -- event = 'VeryLazy',
  -- ft = "markdown" -- If you decide to lazy-load anyway

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    'nvim-treesitter/nvim-treesitter',

    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local presets = require('markview.presets').headings

    require('markview').setup {
      headings = presets.simple,
    }
  end,
}
