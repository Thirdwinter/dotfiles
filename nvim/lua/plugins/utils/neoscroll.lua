return {
  "karb94/neoscroll.nvim",
  opts = function(_, opts)
    opts.mappings = { -- Keys to be mapped to their corresponding default scrolling animation
      -- '<C-u>', '<C-d>',
      -- '<C-b>', '<C-f>',
      -- '<C-y>', '<C-e>',
      -- 'zt', 'zz', 'zb',
    }
    opts.hide_cursor = false         -- Hide cursor while scrolling
    opts.optsstop_eof = true         -- Stop at <EOF> when scrolling downwards
    opts.respect_scrolloff = false   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    opts.cursor_scrolls_alone = true -- The cursor will keep on scrolling even if the window cannot scroll further
    opts.duration_multiplier = 0.4   -- Global duration multiplier
    opts.easing = 'linear'           -- Default easing function
    opts.pre_hook = nil              -- Function to run before the scrolling animation starts
    opts.post_hook = nil             -- Function to run after the scrolling animation ends
    opts.performance_mode = false    -- Disable "Performance Mode" on all buffers.
    opts.ignored_events = {          -- Events ignored while scrolling
      'WinScrolled', 'CursorMoved'
    }
    local neoscroll = require('neoscroll')
    local keymap = {
      ["<C-u>"] = function() neoscroll.scroll(-10, { move_cursor = true, duration = 50 }) end,
      ["<C-d>"] = function() neoscroll.scroll(10, { move_cursor = true, duration = 50 }) end,
      ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 200 }) end,
      ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 200 }) end,
      ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 }) end,
      ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 50 }) end,
      ["zt"]    = function() neoscroll.zt({ half_win_duration = 50 }) end,
      ["zz"]    = function() neoscroll.zz({ half_win_duration = 50 }) end,
      ["zb"]    = function() neoscroll.zb({ half_win_duration = 50 }) end,
      -- ["j"]     = function() neoscroll.scroll(10, { move_cursor = true, duration = 50 }) end,
      -- ["k"]     = function() neoscroll.scroll(-10, { move_cursor = true, duration = 50 }) end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end
}
