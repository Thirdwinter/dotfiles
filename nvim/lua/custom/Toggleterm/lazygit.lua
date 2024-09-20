local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new {
  cmd = 'lazygit',
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

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap('n', '<leader>tg', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true, desc = 'float lazygit' })
