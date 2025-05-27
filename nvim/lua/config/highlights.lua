vim.api.nvim_set_hl(0, '@variable.parameter', vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = '@variable.parameter' }), { italic = true, bold = true }))
vim.api.nvim_set_hl(0, 'Boolean', vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Boolean' }), { italic = true, bold = true }))
vim.api.nvim_set_hl(0, 'Statement', vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Statement' }), { italic = true }))
vim.api.nvim_set_hl(0, 'Comment', vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Comment' }), { italic = true, bold = true }))
vim.api.nvim_set_hl(0, 'Type', vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = 'Type' }), { italic = true, bold = false }))

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
