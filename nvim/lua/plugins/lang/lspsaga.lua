if true then
  return {}
end
return {
  'nvimdev/lspsaga.nvim',
  event = 'VeryLazy',
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
    opts.symbol_in_winbar = {
      enable = true,
      separator = ' › ',
      hide_keyword = false,
      ignore_patterns = nil,
      show_file = true,
      folder_level = 1,
      color_mode = false,
      delay = 300,
    }
    opts.ui = {
      border = 'single',
    }
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  },
}
