-- 设置空格作为 leader 键
-- 参见 `:help mapleader`
--  注意：必须在插件加载之前设置（否则会使用错误的 leader）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 如果你在终端中安装并选择了 Nerd 字体，则设置为 true
vim.g.have_nerd_font = true

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
vim.opt.list = true
vim.opt.listchars = { tab = '╎ ', trail = '·', nbsp = '␣' }

-- 实时预览替换，边输入边预览！
vim.opt.inccommand = 'split'

-- 显示光标所在的行
vim.opt.cursorline = true

-- 在光标上方和下方保持的最小屏幕行数
vim.opt.scrolloff = 10

-- 4格tap
vim.opt.tabstop = 2

-- only one statusline
vim.opt.laststatus = 3
-- 禁用击键回显
vim.opt.showcmd = false

vim.cmd.language 'zh_CN.UTF-8'
-- 使用系统剪切板--
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
vim.opt.foldenable = true -- enable fold for nvim-ufo
vim.opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
vim.opt.foldlevelstart = 99 -- start with all code unfolded
-- vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
