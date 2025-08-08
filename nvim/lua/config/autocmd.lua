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

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('TopTrim', { clear = true }),
  once = true,
  callback = function()
    local FILE  = vim.fn.expand(vim.fn.stdpath('state') .. '/lsp.log') -- 目标文件
    local LIMIT = 1024 * 1024 * 5                                      -- 超过 5 MB 就裁剪
    local KEEP  = 100                                                  -- 保留最后 100 行
    local size  = vim.fn.getfsize(FILE)
    if size == -1 or size <= LIMIT then return end

    -- 异步 tail
    vim.system(
      { 'tail', '-n', tostring(KEEP), FILE },
      { text = true },
      function(obj)
        if obj.code == 0 then
          vim.schedule(function()
            vim.fn.writefile(
              vim.split(obj.stdout, '\n', { plain = true, trimempty = false }),
              FILE
            )
            vim.notify(string.format('已裁剪 %s，仅保留最后 %d 行', FILE, KEEP),
              vim.log.levels.INFO)
          end)
        else
          vim.schedule(function()
            vim.notify(string.format('裁剪 %s 失败：%s', FILE, obj.stderr or '未知错误'),
              vim.log.levels.ERROR)
          end)
        end
      end
    )
  end
})
