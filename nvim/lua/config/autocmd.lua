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
--local resession = require 'resession'
-- Automatically save sessions on by working directory on exit
-- vim.api.nvim_create_autocmd('VimLeavePre', {
--   callback = function()
--     resession.save(vim.fn.getcwd(), { notify = true })
--   end,
-- })
-- vim.api.nvim_create_autocmd('VimLeavePre', {
--   callback = function()
--     resession.save 'last'
--   end,
-- })
-- vim.api.nvim_create_autocmd({ 'BufNew', 'BufNewFile', 'BufRead' }, {
--   callback = function()
--     if #vim.fn.getbufinfo { buflisted = 1 } >= 2 then
--       vim.o.showtabline = 2 -- 总是显示
--     elseif vim.o.showtabline ~= 1 then -- 不重置已经为默认值的选项
--       vim.o.showtabline = 1 -- 仅当标签页多于 1 时显示
--     end
--   end,
-- })

local get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

-- initialize the buflist cache
local buflist_cache = {}

-- Create autocmd for relevant events
vim.api.nvim_create_autocmd({ 'WinEnter', 'VimEnter', 'BufEnter', 'UIEnter', 'BufAdd', 'BufDelete' }, {
  callback = function()
    vim.schedule(function()
      local buffers = get_bufs()
      for i, v in ipairs(buffers) do
        buflist_cache[i] = v
      end
      for i = #buffers + 1, #buflist_cache do
        buflist_cache[i] = nil
      end

      -- check how many buffers we have and set showtabline accordingly
      if #buflist_cache > 1 then
        vim.o.showtabline = 2 -- always
      else -- don't reset the option if it's already at default value
        vim.o.showtabline = 1 -- only when #tabpages > 1
      end
    end)
  end,
})

vim.api.nvim_create_autocmd(
  'ExitPre',
  { group = vim.api.nvim_create_augroup('Exit', { clear = true }), command = 'set guicursor=a:ver90', desc = 'Set cursor back to beam when leaving Neovim' }
)

local function augroup(name)
  return vim.api.nvim_create_augroup('ths_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})
