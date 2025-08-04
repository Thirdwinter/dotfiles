vim.o.statuscolumn = [[%!v:lua.require'custom.Snacks.co'.get()]]
return {
  require("custom.DropBar")
}
