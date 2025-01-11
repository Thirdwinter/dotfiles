--INFO: 强化'%'选中
return {
  'andymass/vim-matchup',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    vim.g.matchup_matchparen_offscreen = { methon = 'popup' }
  end,
}
