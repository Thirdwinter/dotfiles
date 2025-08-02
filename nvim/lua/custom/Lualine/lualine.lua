local lualine = require 'lualine'
local separators = require('custom.Lualine.chars').separators
local spinner_chars = require('custom.Lualine.chars').spinner_char

---@diagnostic disable-next-line: unused-local
local left_separators = separators.left_rounded
local right_separators = separators.right_rounded

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

-- ---@diagnostic disable-next-line: unused-function, unused-local
-- local function lsp_info()
--   local msg = require('lsp-progress').progress()
--   return vim.api.nvim_win_get_width(0) < 110 and '' or msg
--
--   -- return msg
-- end

local function file_info()
  local filename = vim.fn.expand '%:t'
  local extension = vim.fn.expand '%:e'
  local present, icons = pcall(require, 'nvim-web-devicons')
  local icon = present and icons.get_icon(filename, extension) or '󰈙 '
  if vim.api.nvim_win_get_width(0) < 140 then
    return (vim.bo.modified and '%m' or '') .. icon .. ' '
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
      'snacks_dashboard',
      'snacks_picker_list',
      'snacks_terminal',
      'neo-tree',
      'mason',
      'lazy',
      'oil',
      'TelescopePrompt',
      'toggleterm',
      'yazi',
    },
    ignore_focus = { 'neo-tree', 'dashboard', 'snacks_dashboard' },
    -- theme = 'rose-pine', ---@type 'catppuccin' | 'rose-pine' | 'tokyonight' | 'auto'
    theme = require('custom.Lualine.themes.rose-pine'),
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str)
          return vim.api.nvim_win_get_width(0) < 110 and string.format('%-2s', str:sub(1, 1)) or
              string.format('%-8s', str)
        end,
        icon = '󰀘',
        color = { gui = 'bold' },
        separator = { left = separators.vertical_bar, right = ' ' },
        padding = { left = 1, right = 0 },
      },
    },

    lualine_b = {
      {
        'branch',
        icon = { ' ', align = 'left' },
        separator = { right = right_separators },
        padding = { left = 0 },
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
        -- cond = function()
        --   return vim.api.nvim_win_get_width(0) > 110
        -- end,
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
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = '  ', warn = '  ', info = '  ', hint = '  ' },
      },
      {
        'lsp_status',
        ---@diagnostic disable-next-line: unused-local
        fmt = function(str)
          local has_lsp = false
          for _, client in pairs(vim.lsp.get_clients()) do
            if client.initialized or client.progress then
              has_lsp = true
              break
            end
          end
          return (vim.api.nvim_win_get_width(0) < 140)
              and (has_lsp and " " or "󱏎 ")
              or (has_lsp and " LSP" or "󱏎 None")
        end,
        -- icon = '', -- f013
        icon = '', -- f013
        symbols = {
          -- Standard unicode symbols to cycle through for LSP progress:
          spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          -- Standard unicode symbol for when LSP is done:
          done = '',
          -- Delimiter inserted between LSP names:
          separator = ' ',
        },
        -- List of LSP names to ignore (e.g., `null-ls`):
        ignore_lsp = {},
        separator = {},
      },
    },

    lualine_y = {
      {
        file_info,
        separator = { left = left_separators, right = separators.vertical_bar_thin },
        padding = { left = 0, right = 1 },
      }
      -- {
      --   'filename',
      --   file_status = true,     -- Displays file status (readonly status, modified status)
      --   newfile_status = false, -- Display new file status (new file means no write after created)
      --   path = 4,               -- 0: Just the filename
      --   -- 1: Relative path
      --   -- 2: Absolute path
      --   -- 3: Absolute path, with tilde as the home directory
      --   -- 4: Filename and parent dir, with tilde as the home directory
      --
      --   shorting_target = 40, -- Shortens path to leave 40 spaces in the window
      --   -- for other components. (terrible name, any suggestions?)
      --   symbols = {
      --     modified = '[+]',   -- Text to show when the file is modified.
      --     readonly = '[-]',   -- Text to show when the file is non-modifiable or readonly.
      --     unnamed = '[None]', -- Text to show for unnamed buffers.
      --     newfile = '[New]',  -- Text to show for newly created file before first write
      --   },
      --   fmt = function(name)
      --     local present, icons = pcall(require, 'nvim-web-devicons')
      --     ---@diagnostic disable-next-line: unused-local
      --     local icon = present and icons.get_icon(name) or '󰈙 '
      --
      --     return name
      --   end,
      --
      --   -- file_info,
      --   separator = { left = left_separators, right = separators.vertical_bar_thin },
      --   -- padding = { left = 0, right = 1 },
      -- },
    },

    lualine_z = {
      {
        dir_info,
        separator = { right = separators.vertical_bar },
        color = { gui = 'bold' },
        padding = { left = 0, right = 1 },
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

---@diagnostic disable-next-line: unused-local, unused-function
local function ins_right(component)
  table.insert(config.sections.lualine_c, component)
end

-- ins_right '%='

-- ins_right {
--   'diagnostics',
--   sources = { 'nvim_diagnostic' },
--   symbols = { error = '  ', warn = '  ', info = '  ', hint = '  ' },
--   cond = function()
--     local diagnostics = vim.diagnostic.get(0)
--     local count = 0
--     for _ in pairs(diagnostics) do
--       count = count + 1
--     end
--     return count ~= 0
--   end,
-- }

lualine.setup(config)
