-- INFO: set lazyrepo and local path
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require 'config.options' -- INFO: Options must be loaded before plugins
require 'lazy_setup'     -- INFO: loadind lazy plugins
require 'config.autocmd'
require 'config.keymaps'

-- TODO:
-- require "config.lspconfig"

---@type 'tokyonight'|'catppuccin'
vim.cmd.colorscheme 'catppuccin'
-- NOTE: highlights patch
require 'config.highlights'


function _G.camel_to_snake()
  -- 获取当前模式
  local mode = vim.api.nvim_get_mode().mode

  -- 处理 Visual 模式
  if mode:find('[vV]') then
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line, start_col = start_pos[2], start_pos[3] - 1
    local end_line, end_col = end_pos[2], end_pos[3]

    -- 确保在同一行
    if start_line ~= end_line then
      vim.notify("Only single line selections supported", vim.log.levels.WARN)
      return
    end

    -- 获取选中文本
    local line = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
    local selected_text = line:sub(start_col + 1, end_col)

    -- 转换并替换
    local converted = selected_text:gsub("([a-z])([A-Z])", "%1_%2")
        :gsub("([A-Z]+)([A-Z][a-z])", "%1_%2")
        :lower()
    vim.api.nvim_buf_set_text(0, start_line - 1, start_col, start_line - 1, end_col, { converted })

    -- 处理 Normal 模式
  else
    local word = vim.fn.expand('<cword>')
    if word == '' then return end

    -- 转换逻辑
    local converted = word:gsub("([a-z])([A-Z])", "%1_%2")
        :gsub("([A-Z]+)([A-Z][a-z])", "%1_%2")
        :lower()

    -- 替换当前单词
    vim.cmd('normal! ciw' .. converted)
  end
end

-- 绑定到 <leader>ts
vim.api.nvim_set_keymap('n', '<leader>ts', '<cmd>lua camel_to_snake()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>ts', '<cmd>lua camel_to_snake()<CR>', { noremap = true, silent = true })
