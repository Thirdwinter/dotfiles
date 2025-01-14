return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  opts = {
    level = 2,
    render = 'wrapped-compact',
    stages = 'slide',
    timeout = 1000,
    max_height = function()
      return math.ceil(vim.api.nvim_win_get_height(0) * 0.55)
    end,
    max_width = function()
      return math.ceil(vim.api.nvim_win_get_width(0) * 0.55)
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
