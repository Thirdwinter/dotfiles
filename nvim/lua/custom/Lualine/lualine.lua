local separators = require('custom.Lualine.chars').separators
local spinner_chars = require('custom.Lualine.chars').spinner_char
local catppuccin_theme_mode_color = require('custom.Lualine.themes.catppuccin').mode_color

local colors = {
  blue = '#80a0ff',
  yellow = '#ECBE7B',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  magenta = '#c678dd',
  cyan = '#79dac8',
  black = '#080808',
  white = '#c6c6c6',
  red = '#ff5189',
  violet = '#d183e8',
  grey = '#303030',
}

-- 分隔符
local slant_sep = { left = separators.slant_left, right = separators.slant_right_2 }
-- local rounded_sep = { left = separators.left_rounded, right = separators.right_rounded }

local function vimmode()
  return ''
end

local function vimmode_hl()
  return { fg = colors.black }
end

local function scroll_bar()
  local chars = setmetatable(spinner_chars, {
    __index = function()
      return ' '
    end,
  })
  local line_ratio = vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0)
  local position = math.floor(line_ratio * 100)
  local icon = chars[math.floor(line_ratio * #chars)] .. position
  if position <= 10 or vim.api.nvim_win_get_cursor(0)[1] == 1 then
    icon = 'TOP'
  elseif (vim.api.nvim_buf_line_count(0) - vim.api.nvim_win_get_cursor(0)[1]) == 0 then
    icon = 'BOT'
  end
  return icon
end

local function scroll_bar_hl()
  local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
  local fg = position <= 10
    or vim.api.nvim_win_get_cursor(0)[1] == 1 and 'yellow'
    or (vim.api.nvim_buf_line_count(0) - vim.api.nvim_win_get_cursor(0)[1]) == 0 and colors.red
    or nil
  local gui = fg and 'bold' or ''
  return { fg = fg, gui = gui }
end

local function lsp_info()
  local msg = require('lsp-progress').progress()
  return vim.api.nvim_win_get_width(0) < 80 and '' or msg
end

local function search_count()
  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
  if not ok or not next(result) then
    return ''
  end
  local denominator = math.min(result.total, result.maxcount)
  return string.format(' [%d/%d] ', result.current, denominator)
end

local function micro()
  local recording_register = vim.fn.reg_recording()
  return #recording_register > 0 and string.format(' Recording @%s ', recording_register) or ''
end

local function sep()
  return string.format('%s%s', separators.slant_left, separators.slant_right_2)
end

local function getGreeting()
  local tableTime = os.date '*t'
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = ' Sleep well',
    [2] = ' Good morning',
    [3] = ' Good afternoon',
    [4] = ' Good evening',
    [5] = ' Good night',
  }
  local greetingIndex = (hour == 23 or hour < 7) and 1 or (hour < 12) and 2 or (hour < 18) and 3 or (hour < 21) and 4 or 5
  return vim.api.nvim_win_get_width(0) < 80 and '' or greetingsTable[greetingIndex]
end

local function timing()
  local datetime = os.date ' %Y-%m-%d-%A   %H:%M:%S '
  return string.format('%s', datetime)
end

local Config = {
  options = {
    disabled_filetypes = {
      'alpha',
      'dashboard',
      'neo-tree',
      'mason',
      'lazy',
      'oil',
      'TelescopePrompt',
      'toggleterm',
      'yazi',
    },
    ignore_focus = { 'neo-tree', 'alpha' },
    theme = 'catppuccin',
  },
  sections = {
    lualine_a = {
      { vimmode, color = vimmode_hl, separator = { left = separators.left_rounded, right = separators.slant_right_2 }, padding = { left = 1, right = 1 } },
    },
    lualine_b = {
      {
        'branch',
        separator = slant_sep,
      },
      { sep, separator = slant_sep },
      { lsp_info, separator = slant_sep, padding = { left = 0, right = 0 } },
      { sep, separator = slant_sep },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = { error = { fg = colors.red }, warn = { fg = colors.yellow }, info = { fg = colors.cyan } },
        separator = slant_sep,
      },
    },
    lualine_c = {
      {
        timing,
        color = function()
          return { fg = catppuccin_theme_mode_color[vim.fn.mode()] }
        end,
        separator = { right = separators.slant_left },
        cond = function()
          return vim.api.nvim_win_get_width(0) > 140
        end,
      },
      {
        getGreeting,
        color = function()
          return { fg = catppuccin_theme_mode_color[vim.fn.mode()] }
        end,
        -- separator = { right = separators.slant_right_2 },
      },
    },
    lualine_x = {},
    lualine_y = {
      { 'filetype', separator = { left = separators.slant_left } },
      { sep, separator = slant_sep },
      { 'location', separator = slant_sep, padding = { left = 0, right = 0 } },
      { sep, separator = slant_sep },
      {
        search_count,
        separator = slant_sep,
        cond = function()
          return vim.v.hlsearch ~= 0
        end,
      },
      { micro, separator = slant_sep },
    },
    lualine_z = {
      { scroll_bar, separator = { left = separators.slant_left, right = separators.right_rounded }, color = scroll_bar_hl },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  inactive_tabline = {},
  extensions = {},
}
-- local function ins_left(component)
--   table.insert(Config.sections.lualine_x, component)
-- end
--
-- -- Inserts a component in lualine_c at right section
-- local function ins_right(component)
--   table.insert(Config.sections.lualine_c, component)
-- end

require('lualine').setup(Config)
