if true then
  return {}
end
return {
  'stevearc/oil.nvim',
  opts = function()
    vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' })
    return {
      default_file_explorer = true,
      columns = {
        'icon',
        'permissions',
        -- "size",
        -- "mtime",
      },
      keymaps = {
        ['-'] = 'actions.close',
        ['<BS>'] = 'actions.parent',
      },
    }
  end,
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
}
