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
            -- separator = true,
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
  -- keys = {
  --   { '<Leader>bp', '<Cmd>BufferLinePick<CR>', desc = '选择buffer' },
  --   { '<Leader>bd', '<Cmd>BufferLinePickClose<CR>', desc = '选择buffer关闭' },
  --   { '<Leader>bh', '<Cmd>BufferLineCloseLeft<CR>', desc = '关闭左侧buffer' },
  --   { '<Leader>bl', '<Cmd>BufferLineCloseRight<CR>', desc = '关闭右侧buffer' },
  --   { '<Leader>c', "<Cmd>lua require('mini.bufremove').delete(0,false)<CR>", desc = '关闭当前buffer' },
  --   { 'L', '<Cmd>bnext<CR>', desc = '下一个buffer' },
  --   { 'H', '<Cmd>bprev<CR>', desc = '上一个buffer' },
  --   {
  --     '<leader>bo',
  --     '<Cmd>BufferLineCloseOthers<CR>',
  --     desc = '关闭其它buffer',
  --   },
  -- },
}
