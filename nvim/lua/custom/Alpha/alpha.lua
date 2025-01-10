local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
-- DASHBOARD HEADER

local function getGreeting(name)
  local tableTime = os.date '*t'
  local datetime = os.date ' %Y-%m-%d-%A   %H:%M:%S '
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = '  Sleep well',
    [2] = '  Good morning',
    [3] = '  Good afternoon',
    [4] = '  Good evening',
    [5] = '󰖔  Good night',
  }
  local greetingIndex = 0
  if hour == 23 or hour < 7 then
    greetingIndex = 1
  elseif hour < 12 then
    greetingIndex = 2
  elseif hour >= 12 and hour < 18 then
    greetingIndex = 3
  elseif hour >= 18 and hour < 21 then
    greetingIndex = 4
  elseif hour >= 21 then
    greetingIndex = 5
  end
  return datetime .. '  ' .. greetingsTable[greetingIndex] .. ', ' .. name
end

local logo = require('custom.Alpha.logo').neovim
dashboard.section.buttons.val = {
  dashboard.button('f', '  Find file', '<CMD>silent Telescope find_files hidden=true no_ignore=true <CR>'),
  dashboard.button('t', '  Find text', '<CMD>silent Telescope live_grep <CR>'),
  dashboard.button('r', '󰄉  Recent files', ':Telescope oldfiles <CR>'),
  dashboard.button('u', '󱐥  Update plugins', '<CMD>Lazy update<CR>'),
  dashboard.button('n', '  Neovim Settings', "<CMD>lua require 'telescope.builtin'.find_files { cwd = vim.fn.stdpath 'config' } <CR>"),
  dashboard.button('l', '  Load Session', "<CMD>lua require('resession').load 'last'<CR>"),
  dashboard.button('q', '󰿅  Quit', '<CMD>qa<CR>'),
  -- dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
  -- dashboard.button('c', '  Settings', ':e $HOME/.config/nvim/init.lua<CR>'),
  -- dashboard.button('p', '  Projects', ':e $HOME/Documents/github <CR>'),
  -- dashboard.button('d', '󱗼  Dotfiles', ':e $HOME/dotfiles <CR>'),
}

dashboard.section.footer.val = getGreeting(vim.g.Username)

dashboard.section.header.val = vim.split(logo, '\n')
dashboard.section.header.opts = { hl = 'DashboardFooter', position = 'center' }
dashboard.config.layout = {
  { type = 'padding', val = 2 },
  dashboard.section.header,
  { type = 'padding', val = 1 },
  dashboard.section.buttons,
  { type = 'padding', val = 1 },
  dashboard.section.footer,
}

dashboard.opts.opts.noautocmd = false
alpha.setup(dashboard.opts)
