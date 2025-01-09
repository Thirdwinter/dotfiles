-- 导入必要的模块
local vim_diagnostic = vim.diagnostic

-- 定义诊断图标
local signs = {
  { name = 'DiagnosticSignError', text = '', color = 'DiagnosticError' },
  { name = 'DiagnosticSignWarn', text = '', color = 'DiagnosticWarn' },
  { name = 'DiagnosticSignHint', text = '', color = 'DiagnosticHint' },
  { name = 'DiagnosticSignInfo', text = '', color = 'DiagnosticInfo' },
}

-- 注册诊断图标
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.color, numhl = '' })
end

-- 配置诊断显示
return {
  vim_diagnostic.config {
    -- underline = true,
    -- update_in_insert = false,
    -- virtual_text = {
    --   spacing = 4,
    --   perfix = '●',
    -- },
    signs = { active = signs }, -- 是否在边缘显示诊断图标
    underline = true, -- 是否给诊断信息下的文本加下划线
    severity_sort = true, -- 是否根据严重性级别排序
    update_in_insert = true, -- 在插入模式下是否更新诊断信息
    float = { -- 浮动窗口的配置
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      -- source = 'always',
      header = '',
      prefix = '',
    },
  },
}
