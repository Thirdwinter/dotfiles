--INFO: 一些自定义的颜色

vim.cmd.colorscheme 'catppuccin-mocha' ---@type 'tokyonight'|'catppuccin'|'rose-pine-main'|'nightfox'|'terafox'|'dracula'|'dracula-soft'
-- Hide semantic highlights for functions
-- vim.api.nvim_set_hl(0, '@lsp.type.function', {})

-- vim.api.nvim_set_hl(0, 'CmpCursorLine', { bg = '#a6e3a1', fg = '#1e1e2e', bold = true })
-- Hide all semantic highlights
-- for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
--   vim.api.nvim_set_hl(0, group, {})
-- end

vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#4F536D' })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#138376' })
