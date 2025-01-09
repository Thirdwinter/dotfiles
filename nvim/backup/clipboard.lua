if true then
  return {}
end
return {
  'EtiamNullam/deferred-clipboard.nvim',
  config = function()
    require('deferred-clipboard').setup {
      lazy = true,
      force_init_unnamed = true,
    }
  end,
}
