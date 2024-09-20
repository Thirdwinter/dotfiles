local Terminal = require('toggleterm.terminal').Terminal

local zsh = Terminal:new {
  cmd = 'zsh',
  direction = 'float',
  float_opts = {
    border = 'double',
  },
  on_open = function(term)
    vim.cmd 'startinsert!'
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
  on_close = function(term)
    vim.cmd 'startinsert!'
  end,
}
function _zsh_toggle()
  zsh:toggle()
end
-- 设置键映射
vim.api.nvim_set_keymap('n', '<leader>tz', '<cmd>lua _zsh_toggle()<CR>', { noremap = true, silent = true, desc = 'float zsh' })

local nu = Terminal:new {
  cmd = 'nu.exe',
  direction = 'float',
  float_opts = {
    border = 'double',
  },
  on_open = function(term)
    vim.cmd 'startinsert!'
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
  on_close = function(term)
    vim.cmd 'startinsert!'
  end,
}
function _nu_toggle()
  nu:toggle()
end
-- 设置键映射
vim.api.nvim_set_keymap('n', '<leader>tn', '<cmd>lua _nu_toggle()<CR>', { noremap = true, silent = true, desc = 'float nushell' })

function _shell_toggle()
  if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
    _nu_toggle()
  elseif vim.fn.has 'unix' == 1 then
    _zsh_toggle()
  end
end

vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>lua _shell_toggle()<CR>', { noremap = true, silent = true, desc = 'float shell' })

vim.api.nvim_set_keymap('n', '<F7>', '<cmd>lua _shell_toggle()<CR>', { noremap = true, silent = true, desc = 'float shell' })
vim.api.nvim_set_keymap('i', '<F7>', '<Esc><cmd>lua _shell_toggle()<CR>', { noremap = true, silent = true, desc = 'float shell' })
