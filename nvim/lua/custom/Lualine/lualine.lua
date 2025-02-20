local lualine = require 'lualine'
local catppuccin_theme_mode_color = require('custom.Lualine.themes.catppuccin').mode_color
local separators = require('custom.Lualine.chars').separators
local spinner_chars = require('custom.Lualine.chars').spinner_char

local left_separators = separators.left_some
local right_separators = separators.right_some

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
    return ' TOP'
  elseif (vim.api.nvim_buf_line_count(0) - vim.api.nvim_win_get_cursor(0)[1]) == 0 then
    return ' BOT'
  else
    return string.format('%s', icon) .. '%%'
  end
end

local function scroll_bar_hl()
  local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
  local fg
  if position <= 10 or vim.api.nvim_win_get_cursor(0)[1] == 1 then
    fg = '#5adaff'
  elseif (vim.api.nvim_buf_line_count(0) - vim.api.nvim_win_get_cursor(0)[1]) == 0 then
    fg = '#ff6d36'
  else
    fg = '#D3D3D3'
  end
  return { fg = fg }
end

local function dir_info()
  local current_dir = vim.fn.getcwd()
  local home_dir = vim.fn.expand '~'
  local dir_name = current_dir == home_dir and '~' or vim.fn.fnamemodify(current_dir, ':t')
  return vim.api.nvim_win_get_width(0) < 110 and string.format('%s', '󰉖 ') or string.format('%s %s', '󰉖 ', dir_name)
end

local function lsp_info()
  local msg = require('lsp-progress').progress()
  -- return vim.api.nvim_win_get_width(0) < 110 and '' or msg

  return msg
end

local function file_info()
  local filename = vim.fn.expand '%:t'
  local extension = vim.fn.expand '%:e'
  local present, icons = pcall(require, 'nvim-web-devicons')
  local icon = present and icons.get_icon(filename, extension) or '󰈙 '
  if vim.api.nvim_win_get_width(0) < 140 then
    return (vim.bo.modified and '%m' or '') .. ' ' .. icon .. ' '
  end
  return (vim.bo.modified and '%m' or '') .. ' ' .. icon .. ' ' .. filename .. ' '
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

-- Config
local config = {
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
    -- theme = require('custom.Lualine.themes.cp').catppuccin(),
    theme = 'catppuccin', ---@type 'catppuccin' | 'rose-pine' | 'tokyonight'
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str)
          return vim.api.nvim_win_get_width(0) < 110 and str:sub(1, 1) or str
        end,
        icon = '󰀘',
        color = { gui = 'bold' },
        separator = { left = left_separators, right = right_separators },
      },
    },

    lualine_b = {
      {
        'branch',
        icon = { ' ', align = 'left' },
        separator = { right = right_separators },
        padding = { left = 1 },
      },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        separator = { right = right_separators },
        padding = { right = 0, left = 1 },
      },
    },
    lualine_c = {

      { scroll_bar, padding = { right = 0, left = 1 }, color = scroll_bar_hl },
      {
        'location',
        separator = { right = right_separators },
        padding = { left = 1 },
        cond = function()
          return vim.api.nvim_win_get_width(0) > 110
        end,
      },
      {
        search_count,
        cond = function()
          return vim.v.hlsearch ~= 0
        end,
      },
      { micro },
    },
    lualine_x = {
      { lsp_info, separator = { left = left_separators } },
    },

    lualine_y = {
      {
        file_info,
        separator = { right = right_separators, left = left_separators },
        -- padding = { left = 0, right = 1 },
      },
    },

    lualine_z = {
      {
        dir_info,
        separator = { right = right_separators },
        color = { gui = 'bold' },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local function ins_right(component)
  table.insert(config.sections.lualine_c, component)
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
  local datetime = os.date ' %Y-%m-%d   %H:%M '
  return string.format('%s', datetime)
end

ins_right '%='

-- ins_right {
--   timing,
--   color = function()
--     return { fg = catppuccin_theme_mode_color[vim.fn.mode()] }
--   end,
--   separator = { right = separators.slant_left },
--   cond = function()
--     local diagnostics = vim.diagnostic.get(0)
--     local count = 0
--     for _ in pairs(diagnostics) do
--       count = count + 1
--     end
--     return count == 0 and vim.api.nvim_win_get_width(0) > 140
--   end,
-- }
--
-- ins_right {
--   getGreeting,
--   color = function()
--     return { fg = catppuccin_theme_mode_color[vim.fn.mode()] }
--   end,
--   cond = function()
--     local diagnostics = vim.diagnostic.get(0)
--     local count = 0
--     for _ in pairs(diagnostics) do
--       count = count + 1
--     end
--     return count == 0
--   end,
--   -- separator = { right = separators.slant_right_2 },
-- }

ins_right {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = '  ', warn = '  ', info = '  ', hint = '  ' },
  cond = function()
    local diagnostics = vim.diagnostic.get(0)
    local count = 0
    for _ in pairs(diagnostics) do
      count = count + 1
    end
    return count ~= 0
  end,
}

lualine.setup(config)
