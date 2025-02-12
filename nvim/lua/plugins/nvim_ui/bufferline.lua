-- if true then
--   return {}
-- end
return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    vim.keymap.set('n', '<Leader>bp', '<Cmd>BufferLinePick<CR>', { desc = '选择buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>bd', '<Cmd>BufferLinePickClose<CR>', { desc = '选择buffer关闭', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>bh', '<Cmd>BufferLineCloseLeft<CR>', { desc = '关闭左侧buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>bl', '<Cmd>BufferLineCloseRight<CR>', { desc = '关闭右侧buffer', noremap = true, silent = true })
    vim.keymap.set('n', 'L', '<Cmd>bnext<CR>', { desc = '下一个buffer', noremap = true, silent = true })
    vim.keymap.set('n', 'H', '<Cmd>bprev<CR>', { desc = '上一个buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>c', "<Cmd>lua require('mini.bufremove').delete(0,false)<CR>", { desc = '关闭当前buffer', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>bo', function()
      local filetypes = { 'OverseerList', 'Terminal', 'quickfix', 'terminal' }
      local buftypes = { 'terminal', 'toggleterm', 'neotree' }

      local current_buf = vim.api.nvim_get_current_buf()
      local buffers = vim.api.nvim_list_bufs()

      for _, bufnr in ipairs(buffers) do
        if bufnr ~= current_buf then
          local buf = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
          local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
          if not vim.tbl_contains(buftypes, buf) and not vim.tbl_contains(filetypes, ft) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end
      end
    end, { desc = '关闭其它buffer', noremap = true, silent = true })

    require('bufferline').setup {
      highlights = {
        buffer_selected = {
          fg = '#94e2d5',
          bg = '',
          bold = true,
          italic = true,
        },

        fill = {
          bg = '',
        },
        background = {
          bg = '',
        },
        tab = {
          bg = '',
        },
        tab_selected = {
          bg = '',
        },
        tab_separator = {
          bg = '',
        },
        tab_separator_selected = {
          bg = '',
        },
        tab_close = {
          bg = '',
        },
        close_button = {
          bg = '',
        },
        close_button_visible = {
          bg = '',
        },
        close_button_selected = {
          bg = '',
        },
        buffer_visible = {
          bg = '',
        },
        numbers = {
          bg = '',
        },
        numbers_visible = {
          bg = '',
        },
        numbers_selected = {
          bg = '',
        },
        diagnostic = {
          bg = '',
        },
        diagnostic_visible = {
          bg = '',
        },
        diagnostic_selected = {
          bg = '',
        },
        hint = {
          bg = '',
        },
        hint_visible = {
          bg = '',
        },
        hint_selected = {
          bg = '',
        },
        hint_diagnostic = {
          bg = '',
        },
        hint_diagnostic_visible = {
          bg = '',
        },
        hint_diagnostic_selected = {
          bg = '',
        },
        info = {
          bg = '',
        },
        info_visible = {
          bg = '',
        },
        info_selected = {
          bg = '',
        },
        info_diagnostic = {
          bg = '',
        },
        info_diagnostic_visible = {
          bg = '',
        },
        info_diagnostic_selected = {
          bg = '',
        },
        warning = {
          bg = '',
        },
        warning_visible = {
          bg = '',
        },
        warning_selected = {
          bg = '',
        },
        warning_diagnostic = {
          bg = '',
        },
        warning_diagnostic_visible = {
          bg = '',
        },
        warning_diagnostic_selected = {
          bg = '',
        },
        error = {
          bg = '',
        },
        error_visible = {
          bg = '',
        },
        error_selected = {
          bg = '',
        },
        error_diagnostic = {
          bg = '',
        },
        error_diagnostic_visible = {
          bg = '',
        },
        error_diagnostic_selected = {
          bg = '',
        },
        modified = {
          bg = '',
        },
        modified_visible = {
          bg = '',
        },
        modified_selected = {
          bg = '',
        },
        duplicate_selected = {
          bg = '',
        },
        duplicate_visible = {
          bg = '',
        },
        duplicate = {
          bg = '',
        },
        separator_selected = {
          bg = '',
        },
        separator_visible = {
          bg = '',
        },
        separator = {
          bg = '',
        },
        indicator_visible = {
          bg = '',
        },
        indicator_selected = {
          bg = '',
        },
        pick_selected = {
          bg = '',
        },
        pick_visible = {
          bg = '',
        },
        pick = {
          bg = '',
        },
        offset_separator = {
          bg = '',
        },
        trunc_marker = {
          bg = '',
        },
      },

      options = {
        indicator = {
          icon = '', -- this should be omitted if indicator style is not 'icon'
          style = 'none', ---@type 'icon' | 'underline' | 'none'
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
            -- separator = true,
          },
        },

        themable = false,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        tab_size = 5,
      },
    }
  end,
}
