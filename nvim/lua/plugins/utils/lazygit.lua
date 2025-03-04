if true then
  return {}
end
return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  lazy = true,
  -- event = 'VeryLazy',
  cmd = { 'LazyGit', 'LazyGitCurrentFile' },
  keys = {
    { '<leader>gg', '<cmd>LazyGitCurrentFile<CR>', desc = 'Open LazyGit' },
  },
}
