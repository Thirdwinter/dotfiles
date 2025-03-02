return {
  'echasnovski/mini.files',
  event = 'VeryLazy',
  version = false,
  opts = function(_, opts)
    opts.windows = {
      preview = false,
      width_preview = 40,
    }
    vim.keymap.set('n', '<leader>o', function()
      if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end
    end)
  end,
}
