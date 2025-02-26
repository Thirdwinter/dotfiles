if true then
  return {}
end
return {
  'nvim-pack/nvim-spectre',
  lazy = true,
  cmd = { 'Spectre' },
  config = function()
    require('spectre').setup()
  end,
}
