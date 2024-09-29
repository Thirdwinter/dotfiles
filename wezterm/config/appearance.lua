local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local gpus = wezterm.gui.enumerate_gpus()
local colors = require('colors.custom')
return {
   animation_fps = 60,
   max_fps = 60,
   webgpu_preferred_adapter = gpus[1],
   front_end = 'WebGpu', -- WebGpu OpenGL
   webgpu_power_preference = 'HighPerformance',

   colors = {
      cursor_bg = '#f38ba8',
      -- background = '#1f1f28',
      cursor_border = '#f5e0dc',
      cursor_fg = '#11111b',
   },
   color_scheme = 'catppuccin-mocha', ---@type 'duskfox'| 'Dracula+' | 'Tokyo Night Moon' |'catppuccin-mocha'

   window_background_opacity = 0.2,
   term = 'xterm-256color',
   -- background
   background = {
      {
         source = { File = wezterm.GLOBAL.background },
         -- height = '100%',
         -- width = '100%',
         opacity = 0.1,
      },
      {
         source = { Color = colors.background },
         height = '100%',
         width = '100%',
         opacity = 0.2,
      },
   },

   -- scrollbar
   enable_scroll_bar = false,

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = true,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = true,
   use_fancy_tab_bar = true,
   -- show_close_tab_button_in_tabs = false,

   -- window
   window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
   integrated_title_button_style = 'Windows',
   integrated_title_button_color = 'auto',
   integrated_title_button_alignment = 'Right',
   initial_cols = 108,
   initial_rows = 30,
   window_padding = { left = 3, right = 3, top = 3, bottom = 0 },
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#181825',
      inactive_titlebar_bg = '#181825',
   },
   inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
}
