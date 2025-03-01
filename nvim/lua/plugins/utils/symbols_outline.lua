if true then
  return {}
end
return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  opts = {},
  keys = {
    { '<leader>lso', '<CMD>Outline<CR>', { desc = '[S]ymblol [O]utline' } },
  },
}
