return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  opts = {
    level = 2,
    render = 'wrapped-compact',
    stages = 'slide',
    timeout = 1000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.50)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
  init = function()
    local notify = require 'notify'
    vim.notify = notify
  end,
}
