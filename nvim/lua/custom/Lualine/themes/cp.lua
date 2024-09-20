local M = {}

local cp = require('catppuccin.palettes').get_palette 'macchiato'
local O = require('catppuccin').options
M.catppuccin = function()
  local catppuccin = {}

  local transparent_bg = O.transparent_background and 'NONE' or cp.mantle

  catppuccin.normal = {
    a = { bg = cp.flamingo, fg = cp.mantle, gui = 'bold' },
    b = { bg = cp.red, fg = cp.base },
    c = { bg = transparent_bg, fg = cp.text },
  }

  catppuccin.insert = {
    a = { bg = cp.teal, fg = cp.base, gui = 'bold' },
    b = { bg = cp.blue, fg = cp.base },
  }

  catppuccin.terminal = {
    a = { bg = cp.green, fg = cp.base, gui = 'bold' },
    b = { bg = cp.surface0, fg = cp.green },
  }

  catppuccin.command = {
    a = { bg = cp.yellow, fg = cp.base, gui = 'bold' },
    b = { bg = cp.red, fg = cp.text },
  }

  catppuccin.visual = {
    a = { bg = cp.mauve, fg = cp.base, gui = 'bold' },
    b = { bg = cp.surface0, fg = cp.mauve },
  }

  catppuccin.replace = {
    a = { bg = cp.red, fg = cp.base, gui = 'bold' },
    b = { bg = cp.surface0, fg = cp.red },
  }

  catppuccin.inactive = {
    a = { bg = transparent_bg, fg = cp.blue },
    b = { bg = transparent_bg, fg = cp.surface1, gui = 'bold' },
    c = { bg = transparent_bg, fg = cp.overlay0 },
  }

  return catppuccin
end
M.mode_color = {
  n = '#89b4fa',
  i = '#a6e3a1',
  v = '#cba6f7',
  [''] = '#cba6f7',
  V = '#cba6f7',
  c = '#fab387',
  no = '#f38ba8',
  s = '#fab387',
  S = '#fab387',
  [''] ='#fab387',
  ic = '#f9e2af',
  R = '#f38ba8',
  Rv = '#cba6f7',
  cv = '#f38ba8',
  ce = '#f38ba8',
  r = '#f38ba8',
  rm = '#f38ba8',
  ['r?'] = "#94e2d5',
  ['!'] = '#f38ba8',
  t = '#f38ba8',
}

return M
