local wezterm = require('wezterm')
local platform = require('utils.platform')

local font = 'Maple Mono NF CN'
-- local font = 'Monospace Radon'
-- local font = 'JetBrainsMono Nerd Font'
-- local font = 'DarkMono'
local font_size = 11

return {
   font = wezterm.font(font),
   font_size = font_size,
   warn_about_missing_glyphs = false,

   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
