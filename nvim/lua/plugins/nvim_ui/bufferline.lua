-- if true then
--   return {}
-- end
return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/snacks.nvim',
  },
  -- event = 'VeryLazy',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    vim.keymap.set('n', '<Leader>bp', '<Cmd>BufferLinePick<CR>', { desc = '选择buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>bd', '<Cmd>BufferLinePickClose<CR>',
      { desc = '选择buffer关闭', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>bh', '<Cmd>BufferLineCloseLeft<CR>',
      { desc = '关闭左侧buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>bl', '<Cmd>BufferLineCloseRight<CR>',
      { desc = '关闭右侧buffer', noremap = true, silent = true })
    vim.keymap.set('n', 'L', '<Cmd>bnext<CR>', { desc = '下一个buffer', noremap = true, silent = true })
    vim.keymap.set('n', 'H', '<Cmd>bprev<CR>', { desc = '上一个buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>c', function()
      Snacks.bufdelete.delete()
    end, { desc = '关闭当前buffer', noremap = true, silent = true })

    vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>',
      { desc = '关闭其它buffer', noremap = true, silent = true })

    require('bufferline').setup {
      highlights = {
        buffer_visible = {
          fg = "#ffffff",
          bold = true,
          italic = true,
        },
        buffer_selected = {
          fg = {
            attribute = 'fg',
            highlight = 'FloatBorder',
          },
          bg = {
            attribute = 'bg',
            highlight = 'Normal',
          },
          bold = true,
          italic = true,
        },
        indicator_selected = {
          fg = {
            attribute = 'fg',
            highlight = 'FloatBorder',
          },
          bg = {
            attribute = 'bg',
            highlight = 'Normal',
          },
        },
        --
        fill = {
          bg = {
            attribute = 'bg',
            highlight = 'Normal',
          },
        },
        background = {
          bg = {
            attribute = 'bg',
            highlight = 'Normal',
          },
        },
      },

      options = {
        indicator = {
          icon = '┃', -- this should be omitted if indicator style is not 'icon'
          style = 'icon', ---@type 'icon' | 'underline' | 'none'
        },

        separator_style = { '', '' },
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'center',
            -- separator = true,
          },
        },

        themable = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        tab_size = 5,
      },
    }
  end,
}
