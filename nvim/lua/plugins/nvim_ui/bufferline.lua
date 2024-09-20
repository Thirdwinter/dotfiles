-- if true then
--   return {}
-- end
return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('bufferline').setup {
      highlights = {
        fill = {
          bg = '',
        },
        buffer_selected = {
          fg = '#eba0ac',
          bold = false,
          italic = true,
        },
        indicator_selected = {
          fg = '#eba0ac',
        },
      },

      options = {
        indicator = {
          icon = '┃', -- this should be omitted if indicator style is not 'icon'
          style = 'icon', ---@type 'icon' | 'underline' | 'none'
        },

        get_element_icon = function(element)
          local icon, _ = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
          return icon
        end,
        separator_style = { '', '' },
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'center',
            separator = true,
          },
        },

        themable = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        tab_size = 5,
      },
    }
  end,
}
