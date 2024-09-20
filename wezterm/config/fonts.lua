local wezterm = require('wezterm')
local platform = require('utils.platform')

local font = 'Maple Mono'
-- local font = 'Monospace Radon'
-- local font = 'JetBrainsMono Nerd Font'
-- local font = 'DarkMono'
local font_size = platform().is_win and 11 or 10

return {
   font = wezterm.font(font),
   font_size = font_size,
   warn_about_missing_glyphs = false,

   freetype_load_target = 'Light', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Light', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
