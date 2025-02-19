local M = {}
M.options = {
  win = {
    input = {
      keys = { ['<a-a>'] = 'cycle_win', mode = { 'i', 'n' } },
    },
    list = {
      keys = { ['<a-a>'] = 'cycle_win' },
    },
    preview = {
      keys = {
        ['<Esc>'] = 'close',
        ['q'] = 'close',
        ['i'] = 'focus_input',
        ['<ScrollWheelDown>'] = 'list_scroll_wheel_down',
        ['<ScrollWheelUp>'] = 'list_scroll_wheel_up',
        ['<a-a>'] = 'cycle_win',
      },
    },
  },
}
M.keys = {
  {
    '<leader><space>',
    function()
      Snacks.picker.smart()
    end,
    desc = 'Smart Find Files',
  },

  {
    '<leader>fn',
    function()
      Snacks.picker.smart { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Smart Find Nvim Config',
  },
  {
    '<leader>fb',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Buffers',
  },
  -- {
  --   '<leader>fo',
  --   function()
  --     Snacks.picker.notifications()
  --   end,
  --   desc = 'Notification History',
  -- },
}
return M
