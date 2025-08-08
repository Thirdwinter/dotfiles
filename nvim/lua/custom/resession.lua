local M = {}

-- 保证 buffers 被保存
vim.opt.sessionoptions:append('buffers')

local SESSION_DIR = vim.fn.stdpath('data') .. '/sessions'
vim.fn.mkdir(SESSION_DIR, 'p')

local function session_path()
  return SESSION_DIR .. '/' .. vim.fn.getcwd():gsub('/', '%%') .. '.vim'
end

-- 离开时自动保存
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = vim.api.nvim_create_augroup('AutoSaveSession', { clear = true }),
  callback = function()
    -- 1. 过滤掉 dashboard / help / terminal / quickfix / 无名称 buffer
    local has_normal = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
          vim.api.nvim_buf_is_loaded(buf)
          and vim.api.nvim_get_option_value('buftype', { buf = buf }) == '' -- 普通 buffer
          and vim.api.nvim_get_option_value('buflisted', { buf = buf })
          and vim.fn.bufname(buf) ~= ''                                     -- 有文件名
      then
        has_normal = true
        break
      end
    end

    -- 2. 有正常 buffer 才保存，否则什么也不做
    if has_normal then
      vim.cmd('mksession! ' .. vim.fn.fnameescape(session_path()))
    end
  end,
})

-- 加载
function M.load_last()
  local file = session_path()
  if vim.fn.filereadable(file) == 1 then
    vim.cmd('silent! source ' .. vim.fn.fnameescape(file))
    vim.notify('Session restored: \n' .. file)
  else
    vim.notify('No session for ' .. vim.fn.getcwd(), vim.log.levels.WARN)
  end
end

-- 命令
vim.api.nvim_create_user_command('SessionSave', function()
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session_path()))
  vim.notify('Session saved')
end, {})
vim.api.nvim_create_user_command('SessionLoad', M.load_last, {})

return M
