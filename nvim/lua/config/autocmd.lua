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
      else                    -- don't reset the option if it's already at default value
        vim.o.showtabline = 1 -- only when #tabpages > 1
      end
    end)
  end,
})

vim.api.nvim_create_autocmd(
  'ExitPre',
  {
    group = vim.api.nvim_create_augroup('Exit', { clear = true }),
    command = 'set guicursor=a:ver90',
    desc =
    'Set cursor back to beam when leaving Neovim'
  }
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

-- 导入包含高亮定义和应用函数的模块
-- local my_highlights = require('config.hl_patch')

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("My_Hl_Patch", { clear = true }),
  callback = function()
    -- 清除模块缓存，强制重新加载 my_highlights.lua
    -- 这一步是关键，它确保每次切换颜色主题时，
    -- my_highlights.lua 中的函数（如 get_existing_hl）能获取到最新的颜色属性
    package.loaded['config.hl_patch'] = nil
    local ok, reloaded_my_highlights = pcall(require, 'config.hl_patch')
    if not ok then
      vim.notify(string.format("重新加载自定义高亮配置时出错: %s", reloaded_my_highlights), vim.log.levels.ERROR)
      return
    end

    -- 调用模块中的 apply 函数
    reloaded_my_highlights.apply()
  end,
})

-- -- 首次启动时应用高亮补丁
-- -- 强制重新加载以确保初始状态也是基于最新计算的
-- local function setup_initial_highlights()
--   package.loaded['config.my_highlights'] = nil
--   local ok, initial_my_highlights = pcall(require, 'config.hl_patch')
--   if not ok then
--     vim.notify(string.format("初始化自定义高亮配置时出错: %s", initial_my_highlights), vim.log.levels.ERROR)
--     return
--   end
--   initial_my_highlights.apply()
-- end
--
-- -- 在配置脚本的最后调用一次
-- setup_initial_highlights()

-- 如果你希望在所有插件和默认颜色方案加载完毕后再应用，可以考虑放在 VimEnter 事件中：
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = vim.api.nvim_create_augroup("My_Initial_Hl", { clear = true }),
--   callback = setup_initial_highlights,
-- })
