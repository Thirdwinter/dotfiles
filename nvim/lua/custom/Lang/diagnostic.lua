-- 导入必要的模块
local vim_diagnostic = vim.diagnostic
-- local mocha = require 'catppuccin.palettes.mocha'
-- -- 添加波浪线样式，不修改高亮颜色
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = mocha.red })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = mocha.yellow })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = mocha.green })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = mocha.sky })
-- 定义诊断图标
local signs = {
  { name = 'DiagnosticSignError', text = '', color = 'DiagnosticError' },
  { name = 'DiagnosticSignWarn', text = '', color = 'DiagnosticWarn' },
  { name = 'DiagnosticSignHint', text = '', color = 'DiagnosticHint' },
  { name = 'DiagnosticSignInfo', text = '', color = 'DiagnosticInfo' },
}

-- 注册诊断图标
-- for _, sign in ipairs(signs) do
--   vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.color, numhl = '' })
-- end

-- 配置诊断显示
return {
  vim_diagnostic.config {
    virtual_text = false,
    virtual_lines = false,
    -- virtual_lines = {
    --   only_current_line = true,
    -- },
    -- virtual_text = {
    --   spacing = 4,
    --   perfix = '●',
    -- },
    -- signs = { active = signs }, -- 是否在边缘显示诊断图标
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.HINT] = '',
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        [vim.diagnostic.severity.WARN] = 'WarningMsg',
        [vim.diagnostic.severity.INFO] = 'InfoMsg',
        [vim.diagnostic.severity.HINT] = 'HintMsg',
      },
      numhl = {
        [vim.diagnostic.severity.WARN] = 'WarningMsg',
        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        [vim.diagnostic.severity.INFO] = 'InfoMsg',
        [vim.diagnostic.severity.HINT] = 'HintMsg',
      },
    },

    underline = true, -- 是否给诊断信息下的文本加下划线
    severity_sort = true, -- 是否根据严重性级别排序
    update_in_insert = true, -- 在插入模式下是否更新诊断信息
    -- float = false,
    float = { -- 浮动窗口的配置
      focusable = true,
      style = 'minimal',
      border = vim.g.borderStyle,
      -- source = 'always',
      header = '',
      prefix = '',
    },
  },
}
