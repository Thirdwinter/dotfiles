---@diagnostic disable: undefined-global
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
-- stylua: ignore start
M.keys = {
  {'<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files'},
  {'<F8>', function() Snacks.picker.smart() end, desc = 'Smart Find Files', mode = { 'n', 'i', 't' }},
  {'<leader>ft', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes'},
  {'<leader>fh', function() Snacks.picker.help() end, desc = 'Help Pages'},
  {'<leader>fn', function() Snacks.picker.smart { cwd = vim.fn.stdpath 'config' } end, desc = 'Smart Find Nvim Config'},
  {'<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Keymaps'},
  {'<leader>ff', function() Snacks.picker.smart() end, desc = 'Smart Find Files'},
  {'<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers'},
  {'<leader>fl', function() Snacks.picker.lines() end, desc = 'Buffer Lines'},
  {'<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep'},
  {'<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' }},
  {'<leader>fB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers'},
  {'<leader>f.', function() Snacks.picker.resume() end, desc = 'Resume'},
  {'<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent'},
  {'<leader>fD', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics'},
  {'<leader>fd', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics'},
  {'<leader>fo', function() Snacks.picker.noice() end, desc = '[F]ind [O]ld [N]otifications'},
}
-- stylua: ignore end
return M
