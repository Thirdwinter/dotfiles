-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable automatic commenting on newline
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove 'c'
    vim.opt_local.formatoptions:remove 'r'
    vim.opt_local.formatoptions:remove 'o'
  end,
})

--INFO: resession:
local resession = require 'resession'
-- Automatically save sessions on by working directory on exit
-- vim.api.nvim_create_autocmd('VimLeavePre', {
--   callback = function()
--     resession.save(vim.fn.getcwd(), { notify = true })
--   end,
-- })
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    resession.save 'last'
  end,
})
-- vim.api.nvim_create_autocmd({ 'BufNew', 'BufNewFile', 'BufRead' }, {
--   callback = function()
--     if #vim.fn.getbufinfo { buflisted = 1 } >= 2 then
--       vim.o.showtabline = 2 -- 总是显示
--     elseif vim.o.showtabline ~= 1 then -- 不重置已经为默认值的选项
--       vim.o.showtabline = 1 -- 仅当标签页多于 1 时显示
--     end
--   end,
-- })

-- INFO: 主题变化时候重新加载自定义高亮
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.cmd 'source ~/.config/nvim/lua/configs/userhighlights.lua'
  end,
})
