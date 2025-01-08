return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  opts = {
    render = 'compact',
    level = 2,
    stages = 'fade_in_slide_out',
    timeout = 1500,
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
