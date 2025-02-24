-- [[ 基本键位映射 ]]
--  参见 `:help vim.keymap.set()`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>Q', '<Cmd>qa!<CR>', { noremap = true, silent = true, desc = 'Close Nvim' })
vim.keymap.set('n', '<leader>q', '<Cmd>confirm q<CR>', { noremap = true, silent = true, desc = '退出' })
vim.keymap.set('n', '<leader>w', '<Cmd>w!<CR>', { noremap = true, silent = true, desc = 'Save' })
vim.keymap.set('n', '<leader>ld', function()
  vim.diagnostic.open_float { source = true }
end, { noremap = true, silent = true, desc = 'Diagnostic Info' })

-- 分割当前行，光标块内的字符在当前行
vim.keymap.set('n', '<leader>k', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- 获取当前光标位置
  local line = vim.api.nvim_get_current_line() -- 获取当前行内容
  local before = line:sub(1, col + 1) -- 光标前的内容
  local after = line:sub(col + 2) -- 光标后的内容
  vim.api.nvim_set_current_line(before) -- 设置当前行为光标前的内容
  vim.api.nvim_buf_set_lines(0, row, row, false, { after }) -- 在当前行后插入光标后的内容
end, { desc = '分割当前行', noremap = true, silent = true })

--INFO: NeoVide
if vim.g.neovide then
  vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true }) -- Save
  vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true }) -- Copy
  vim.keymap.set('i', '<C-v>', '"+P', { noremap = true, silent = true }) -- Paste normal mode
  -- vim.keymap.set('v', '<C-v>', '"+P', { noremap = true, silent = true }) -- Paste visual mode
  vim.keymap.set('c', '<C-v>', '<C-R>+', { noremap = true, silent = true }) -- Paste command mode
  vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli', { noremap = true, silent = true }) -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
-- vim.api.nvim_set_keymap('', '<C-v>', '+p<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-v>', '<C-R>+', { noremap = true, silent = true })
vim.keymap.set('t', '<C-v>', '<C-R>+', { noremap = true, silent = true })
vim.keymap.set('v', '<C-v>', '<C-R>+', { noremap = true, silent = true })

--  参见 `:help wincmd` 了解所有窗口命令的列表
--INFO: 窗口移动
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = '将焦点移动到左侧窗口' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = '将焦点移动到右侧窗口' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = '将焦点移动到下方窗口' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = '将焦点移动到上方窗口' })

--INFO: 基础相关：
vim.keymap.set('n', '<C-Up>', '<Cmd>resize -2<CR>', { desc = 'Resize split up' })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize +2<CR>', { desc = 'Resize split down' })
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', { desc = 'Resize split left' })
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', { desc = 'Resize split right' })

vim.keymap.set('n', '<A-i>', '<cmd>m .-2<cr>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', '<cmd>m .+1<cr>==', { noremap = true, silent = true })
vim.keymap.set('i', '<A-i>', '<esc><cmd>m .-2<cr>==gi', { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .+1<cr>==gi', { noremap = true, silent = true })
vim.keymap.set('v', '<A-i>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('n', '<C-a>', '<cmd>normal! ggVG<cr>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-a>', '<esc><cmd>normal! ggVG<cr>', { noremap = true, silent = true })

--INFO: 关于注释
vim.api.nvim_set_keymap('n', '<leader>/', 'gcc', { desc = '注释' })
vim.api.nvim_set_keymap('v', '<leader>/', 'gcc<Esc>', { desc = '注释' })

--INFO: 关于Package Manager
vim.keymap.set('n', '<Leader>pl', '<Cmd>Lazy<CR>', { desc = 'Lazy', noremap = true, silent = true })
vim.keymap.set('n', '<Leader>pm', '<Cmd>Mason<CR>', { desc = 'Mason', noremap = true, silent = true })

--INFO: 关于Telescope

-- vim.keymap.set('n', '<F8>', '<Cmd>Telescope find_files<CR>', { desc = 'Open Telescope File Explorer', noremap = true, silent = true })
-- vim.keymap.set('t', '<F8>', '<Cmd>Telescope find_files<CR>', { desc = 'Open Telescope File Explorer', noremap = true, silent = true })
-- vim.keymap.set('i', '<F8>', '<Esc><Cmd>Telescope find_files<CR>', { desc = 'Open Telescope File Explorer', noremap = true, silent = true })
-- vim.keymap.set('n', '<Leader>fct', '<Cmd>Telescope colorscheme<CR>', { desc = '[F]ind [C]olorschemes', noremap = true, silent = true })
-- vim.keymap.set(
--   'n',
--   '<Leader>fo',
--   '<Cmd>lua require("telescope").extensions.notify.notify()<CR>',
--   { desc = '[F]ind [O]ld [N]otifications', noremap = true, silent = true }
-- )
-- local builtin = require 'telescope.builtin'
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
-- vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
-- vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
-- vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
-- vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
-- vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
-- vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing buffers' })
-- vim.keymap.set('n', '<leader>f/', function()
--   builtin.live_grep {
--     grep_open_files = true,
--     prompt_title = 'Live Grep in Open Files',
--   }
-- end, { desc = '[F]ind [/] in Open Files' })
--
-- -- 搜索你的 Neovim 配置文件的快捷方式
-- vim.keymap.set('n', '<leader>fn', function()
--   builtin.find_files { cwd = vim.fn.stdpath 'config' }
-- end, { desc = '[F]ind [N]eovim files' })
--
--INFO: 关于buffer

-- vim.keymap.set('n', '<Leader>bp', '<Cmd>BufferLinePick<CR>', { desc = '选择buffer', noremap = true, silent = true })
-- vim.keymap.set('n', '<Leader>bd', '<Cmd>BufferLinePickClose<CR>', { desc = '选择buffer关闭', noremap = true, silent = true })
-- vim.keymap.set('n', '<Leader>bh', '<Cmd>BufferLineCloseLeft<CR>', { desc = '关闭左侧buffer', noremap = true, silent = true })
-- vim.keymap.set('n', '<Leader>bl', '<Cmd>BufferLineCloseRight<CR>', { desc = '关闭右侧buffer', noremap = true, silent = true })
-- vim.keymap.set('n', 'L', '<Cmd>bnext<CR>', { desc = '下一个buffer', noremap = true, silent = true })
-- vim.keymap.set('n', 'H', '<Cmd>bprev<CR>', { desc = '上一个buffer', noremap = true, silent = true })
-- vim.keymap.set('n', '<Leader>c', "<Cmd>lua require('mini.bufremove').delete(0,false)<CR>", { desc = '关闭当前buffer', noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>bo', function()
--   local filetypes = { 'OverseerList', 'Terminal', 'quickfix', 'terminal' }
--   local buftypes = { 'terminal', 'toggleterm', 'neotree' }
--
--   local current_buf = vim.api.nvim_get_current_buf()
--   local buffers = vim.api.nvim_list_bufs()
--
--   for _, bufnr in ipairs(buffers) do
--     if bufnr ~= current_buf then
--       local buf = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
--       local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
--       if not vim.tbl_contains(buftypes, buf) and not vim.tbl_contains(filetypes, ft) then
--         vim.api.nvim_buf_delete(bufnr, { force = true })
--       end
--     end
--   end
-- end, { desc = '关闭其它buffer', noremap = true, silent = true })

--INFO: 关于Go-To-Preview

-- vim.keymap.set('n', 'gpd', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>', { noremap = true, desc = '预览定义' })
-- vim.keymap.set('n', 'gpt', '<cmd>lua require("goto-preview").goto_preview_type_definition()<CR>', { noremap = true, desc = '预览类型定义' })
-- vim.keymap.set('n', 'gpi', '<cmd>lua require("goto-preview").goto_preview_implementation()<CR>', { noremap = true, desc = '预览实现' })
-- vim.keymap.set('n', 'gpD', '<cmd>lua require("goto-preview").goto_preview_declaration()<CR>', { noremap = true, desc = '预览声明' })
-- vim.keymap.set('n', 'gP', '<cmd>lua require("goto-preview").close_all_win()<CR>', { noremap = true, desc = '关闭所有预览窗口' })
-- vim.keymap.set('n', 'gpr', '<cmd>lua require("goto-preview").goto_preview_references()<CR>', { noremap = true, desc = '预览引用' })

--INFO: 关于session
-- load the session for the current directory

-- local resession = require 'resession'
-- vim.keymap.set('n', '<leader>ss', resession.save, { desc = '[S]ave [Session]' })
-- vim.keymap.set('n', '<leader>sl', resession.load, { desc = '[L]oad [S]ession' })
-- vim.keymap.set('n', '<leader>sd', resession.delete, { desc = '[D]elete [S]ession' })
-- -- select a session to load
-- vim.keymap.set('n', '<leader>sS', '<CMD>Telescope resession<CR>', { desc = '[S]elect [S]ession' })

--INFO: 符号列表

-- vim.keymap.set('n', '<leader>lso', '<CMD>Outline<CR>', { desc = '[S]ymblol [O]utline' })
-- vim.keymap.set('n', '<leader>lsc', '<CMD>SymbolsOutlineClose<CR>', { desc = '[S]ymblol [O]utline [C]lose' })

-- INFO: noice doc

-- vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
--   if not require('noice.lsp').scroll(4) then
--     return '<c-f>'
--   end
-- end, { silent = true, expr = true })
--
-- vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
--   if not require('noice.lsp').scroll(-4) then
--     return '<c-b>'
--   end
-- end, { silent = true, expr = true })
vim.keymap.set('t', '<F7>', '<Cmd>ToggleTerm<CR>', { desc = 'ToggleTerm float' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = '退出终端模式' })

--INFO: 关于neo-tree

-- vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer', noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>o', function()
--   if vim.bo.filetype == 'neo-tree' then
--     vim.cmd.wincmd 'p'
--   else
--     vim.cmd 'Neotree focus'
--   end
-- end, { desc = 'Toggle Explorer Focus', noremap = true, silent = true })

vim.keymap.set({ 'n', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true })

vim.keymap.set({ 'n', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true })
--INFO: Set Emacs keybindings in insert mode
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-f>', '<C-Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-b>', '<C-Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-d>', '<Del>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<C-o>D', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-y>', '<C-r>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-n>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-p>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<BS>', { noremap = true, silent = true })
