vim.api.nvim_set_hl(0, '@variable.parameter',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@variable.parameter' }), { italic = true, bold = true }))
vim.api.nvim_set_hl(0, '@variable',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@variable' }),
    { italic = true, fg = "#B4BEFF" }))

vim.api.nvim_set_hl(0, 'Boolean',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Boolean' }), { italic = true, bold = true }))
vim.api.nvim_set_hl(0, 'Statement',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Statement' }), { italic = true }))
vim.api.nvim_set_hl(0, 'Comment',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Comment' }), { italic = true, bold = true }))
vim.api.nvim_set_hl(0, 'Type',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Type' }), { italic = true, bold = false }))

-- vim.api.nvim_set_hl(0, '@keyword.return',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@keyword.return' }), { italic = true, bold = false }))
--
-- vim.api.nvim_set_hl(0, '@keyword.conditional.ternary',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@keyword.conditional.ternary' }),
--     { italic = true, bold = false }))
--
-- vim.api.nvim_set_hl(0, '@keyword.conditional',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@keyword.conditional' }),
--     { italic = true, bold = false }))
--
-- vim.api.nvim_set_hl(0, '@function',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@function' }),
--     { italic = true, bold = false }))
-- vim.api.nvim_set_hl(0, '@function.method',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@function.method' }),
--     { italic = true, bold = false }))
-- vim.api.nvim_set_hl(0, '@function.builtin',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@function.builtin' }),
--     { italic = true, bold = false }))
--
-- vim.api.nvim_set_hl(0, 'Function',
--   vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Function' }),
--     { italic = true, bold = false }))
--



vim.api.nvim_set_hl(0, 'WinBarNc',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'WinBarNc' }), { bg = "" }))
vim.api.nvim_set_hl(0, 'WinBar',
  vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'WinBar' }), { bg = "" }))


vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#4f536d' })
vim.api.nvim_set_hl(0, 'markdownCodeBlock', { bg = '' })

-- vim.cmd 'highlight clear Label'
-- vim.cmd 'highlight link Label NoiceCmdlinePopupBorder'

vim.cmd 'highlight clear NoiceCmdlinePopupBorder'
vim.api.nvim_set_hl(0, 'MyBorder', { fg = '#B4BEFF' })
vim.cmd 'highlight clear FloatBorder'
vim.cmd 'highlight link FloatBorder MyBorder'

vim.cmd 'highlight clear CursorLineNr'
vim.cmd 'highlight link CursorLineNr MyBorder'

vim.cmd 'highlight clear BlinkCmpLabelMatch'
vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = '#f38ba8' })



--INFO: 一些自定义的颜色

--INFO: 获取主题背景色
-- if not vim.g.transparent() then
--   local normal_hl = vim.api.nvim_get_hl_by_name('Normal', true)
--   local label_hl = vim.api.nvim_get_hl_by_name('Label', true)
--   -- vim.g.Popfg = '#cdd6f5'
--   if normal_hl and normal_hl.background then
--     vim.g.Popbg = string.format('#%06x', normal_hl.background)
--   else
--     vim.g.Popbg = ''
--     -- vim.g.Popfg = ''
--   end
--   if label_hl and label_hl.fg then
--     vim.g.Popfg = string.format('#%06x', normal_hl.background)
--   else
--     vim.g.Popfg = '#138376'
--   end
--
--   -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#4f536d' })
--   -- vim.api.nvim_set_hl(0, 'Visual', { bg = '#138376' })
--
--   vim.api.nvim_set_hl(0, 'UserMenu', { bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'Pmenu', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'PmenuSbar', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'FloatBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'NormalFloat', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'UserMenuBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--
--   vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = vim.g.Popfg, bg = vim.g.Popbg })
--   vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#9399B3' })
--   -- vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#11111b' })
--   -- vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = '#11111b' })
-- end
-- vim.api.nvim_set_hl(0, 'SnacksPicker', { bg = '#4f536d' })
vim.api.nvim_set_hl(0, 'SnacksPickerTitle', { fg = '#11111b', bg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'SnacksPickerInputTitle', { fg = '#11111b', bg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'SnacksPickerPreviewTitle', { fg = '#11111b', bg = '#a6e3a1' })
vim.api.nvim_set_hl(0, 'SnacksPickerListTitle', { fg = '#11111b', bg = '#b4befe' })
