local function getGreeting()
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
  return datetime .. '  ' .. greetingsTable[greetingIndex] .. ', ' .. vim.g.Username
end

return {
  preset = {
    keys = {
      { icon = ' ', key = 'f', desc = 'Find file', action = ':lua Snacks.picker.smart()' },
      { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = ' ', key = 'n', desc = 'Neovim Settings', action = ":lua Snacks.picker.smart { cwd = vim.fn.stdpath 'config' }" },
      {
        icon = ' ',
        key = 'l',
        desc = 'Load Session',
        action = function()
          require('custom.resession').load_last()
          vim.cmd("filetype detect")
        end,
      },
      { icon = ' ', key = 'u', desc = 'Update plugins', action = ':Lazy update' },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
    -- Used by the `header` section
    header = require('custom.logo').A1,
  },
  -- item field formatters
  sections = {
    { section = 'header' },
    { section = 'keys',                                    gap = 1, padding = 1 },
    { text = '\n' },
    { text = { getGreeting(), hl = 'SnacksDashboardDesc' } },
    { section = 'startup' },
  },
}
