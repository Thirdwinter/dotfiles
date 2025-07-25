-- 设置空格作为 leader 键
-- 参见 `:help mapleader`
--  注意：必须在插件加载之前设置（否则会使用错误的 leader）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.codeium_enabled = true

-- vim.o.winborder = 'single'
vim.g.borderStyle = 'single' ---@type 'single'|'rounded'|'none'
-- vim.g.borderStyle = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
-- vim.g.cmpUsed = 'blink' ---@type 'blink' | 'cmp'
vim.g.useMatugenCatppuccinColors = false
-- 如果你在终端中安装并选择了 Nerd 字体，则设置为 true
vim.g.Username = 'ThirdWinter'
vim.g.have_nerd_font = true
vim.g.transparent = function()
  if vim.g.neovide then
    return false
  else
    return true
  end
end

vim.opt.showtabline = 1
vim.opt.laststatus = 3
-- [[ 设置选项 ]]
-- 参见 `:help vim.opt`
-- 注意：你可以根据自己喜好更改这些选项！
--  更多选项，参见 `:help option-list`

-- 使行号成为默认显示
vim.opt.number = true
-- 你也可以添加相对行号，有助于跳跃。
--  自己尝试看看是否喜欢！
vim.opt.relativenumber = true

-- 启用鼠标模式，对于调整分割窗口大小等很有用！
vim.opt.mouse = 'a'

-- 由于状态行中已经有显示，所以不显示模式
vim.opt.showmode = false

-- 同步操作系统和 Neovim 之间的剪贴板。
--  由于可能会增加启动时间，所以安排在 `UiEnter` 之后设置。
--  如果你想让操作系统剪贴板保持独立，请移除此选项。
--  参见 `:help 'clipboard'`
-- vim.schedule(function()
--   vim.opt.clipboard = 'unnamedplus'
-- end)

-- 启用换行缩进
vim.opt.breakindent = true

-- 保存撤销历史
vim.opt.undofile = true

-- 除非搜索词中有大写字母，否则搜索不区分大小写
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 默认保持签名列开启
vim.opt.signcolumn = 'yes'

-- 减少更新时间
vim.opt.updatetime = 250

-- 减少映射序列等待时间
-- 让哪个键提示弹出更快
vim.opt.timeoutlen = 300

-- 配置新分割窗口的打开方式
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 设置 Neovim 如何在编辑器中显示某些空白字符。
--  参见 `:help 'list'`
--  和 `:help 'listchars'`
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 实时预览替换，边输入边预览！
vim.opt.inccommand = 'split'

-- 显示光标所在的行
vim.opt.cursorline = true

-- 在光标上方和下方保持的最小屏幕行数
vim.opt.scrolloff = 10

-- 4格tap
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- only one statusline
vim.opt.laststatus = 3
-- 禁用击键回显
vim.opt.showcmd = false

-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
vim.opt.clipboard = 'unnamedplus'

if not vim.g.neovide then
  if vim.fn.exists '$SSH_TTY' == 1 and vim.env.TMUX == nil then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy '+',
        ['*'] = require('vim.ui.clipboard.osc52').copy '*',
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste '+',
        ['*'] = require('vim.ui.clipboard.osc52').paste '*',
      },
    }
  end
end

-- 设置全局窗口选项，禁止折行
vim.wo.wrap = false

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.foldcolumn = '1'
vim.opt.foldenable = true   -- enable fold for nvim-ufo
vim.opt.foldlevel = 99      -- set high foldlevel for nvim-ufo
vim.opt.foldlevelstart = 99 -- start with all code unfolded
vim.opt.cmdheight = 0

-- vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }

if vim.g.neovide then
  vim.g.neovide_opacity = 0.8
  vim.g.transparency = 0.0
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.g.neovide_background_color = '#1e1e2e'
  vim.o.guifont = 'Maple Mono NF CN:h11.5' -- text below applies for VimScript
end

-- Folding
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = 'expr'
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- INFO: flod
-- Source: https://www.reddit.com/r/neovim/comments/1fzn1zt/custom_fold_text_function_with_treesitter_syntax/
local function fold_virt_text(result, start_text, lnum)
  local text = ''
  local hl
  for i = 1, #start_text do
    local char = start_text:sub(i, i)
    local new_hl

    -- if semantic tokens unavailable, use treesitter hl
    local sem_tokens = vim.lsp.semantic_tokens.get_at_pos(0, lnum, i - 1)
    if sem_tokens and #sem_tokens > 0 then
      new_hl = '@' .. sem_tokens[#sem_tokens].type
    else
      local captured_highlights = vim.treesitter.get_captures_at_pos(0, lnum, i - 1)
      if captured_highlights[#captured_highlights] then
        new_hl = '@' .. captured_highlights[#captured_highlights].capture
      end
    end

    if new_hl then
      if new_hl ~= hl then
        -- as soon as new hl appears, push substring with current hl to table
        table.insert(result, { text, hl })
        text = ''
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end
function _G.custom_foldtext()
  local start_text = vim.fn.getline(vim.v.foldstart):gsub('\t', string.rep(' ', vim.o.tabstop))
  local nline = vim.v.foldend - vim.v.foldstart
  local result = {}
  fold_virt_text(result, start_text, vim.v.foldstart - 1)
  table.insert(result, { ' ', nil })
  table.insert(result, { '◖', '@comment.warning.gitcommit' })
  table.insert(result, { '↙ ' .. nline .. ' lines', '@comment.warning' })
  table.insert(result, { '◗', '@comment.warning.gitcommit' })
  return result
end

vim.opt.foldtext = 'v:lua.custom_foldtext()'
