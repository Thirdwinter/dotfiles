return {
  'echasnovski/mini.files',
  event = 'VeryLazy',
  version = false,
  opts = function(_, opts)
    opts.windows = {
      preview = false,
      width_preview = 40,
    }
    opts.mappings = {
      close = 'q',
      go_in = 'l',
      go_in_plus = 'L',
      go_out = 'h',
      go_out_plus = 'H',
      mark_goto = "'",
      mark_set = 'm',
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '=',
      trim_left = '<',
      trim_right = '>',
    }
    vim.keymap.set('n', '<leader>o', function()
      if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end
    end)
  end,
}
