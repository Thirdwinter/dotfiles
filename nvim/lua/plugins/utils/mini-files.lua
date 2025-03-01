return {
  'echasnovski/mini.files',
  event = 'VeryLazy',
  version = false,
  ---@diagnostic disable-next-line: unused-local
  opts = function(_, opts)
    vim.keymap.set('n', '<leader>o', function()
      if not MiniFiles.close() then
        MiniFiles.open()
      end
    end)
  end,
}
