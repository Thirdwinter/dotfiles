return {
  'mistricky/codesnap.nvim',
  build = 'make build_generator',
  keys = {
    { '<leader>Cc', '<cmd>CodeSnap<cr>', mode = 'x', desc = 'Save selected code snapshot into clipboard' },
    { '<leader>Cs', '<cmd>CodeSnapSave<cr>', mode = 'x', desc = 'Save selected code snapshot in ~/Pictures/nvim_Codesnap' },
  },
  opts = {
    save_path = '~/Pictures/nvim_Codesnap',
    has_breadcrumbs = true,
    bg_theme = 'bamboo',
  },
}