--INFO: 一些自定义的颜色

--INFO: 获取主题背景色
if not vim.g.transparent() then
  local normal_hl = vim.api.nvim_get_hl_by_name('Normal', true)
  -- vim.g.Popfg = '#cdd6f5'
  vim.g.Popfg = '#138376'
  if normal_hl and normal_hl.background then
    vim.g.Popbg = string.format('#%06x', normal_hl.background)
  else
    vim.g.Popbg = ''
    vim.g.Popfg = ''
  end

  -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#4f536d' })
  -- vim.api.nvim_set_hl(0, 'Visual', { bg = '#138376' })

  vim.api.nvim_set_hl(0, 'UserMenu', { bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'UserMenuBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })

  vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
  vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#9399B3' })
  -- vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#11111b' })
  -- vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = '#11111b' })
end
