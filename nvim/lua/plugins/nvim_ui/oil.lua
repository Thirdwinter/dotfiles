-- if true then
--   return {}
-- end
return {

  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@diagnostic disable-next-line: undefined-doc-name
  ---@type oil.SetupOpts
  opts = {
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
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
