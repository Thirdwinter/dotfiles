if true then
  return {}
end
return {
  'echasnovski/mini.animate',
  version = '*',
  config = function()
    require('mini.animate').setup()
  end,
}
