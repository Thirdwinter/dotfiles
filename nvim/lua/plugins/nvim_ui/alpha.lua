if true then
  return {}
end
return {
  'goolord/alpha-nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require 'custom.Alpha.alpha'
  end,
}
