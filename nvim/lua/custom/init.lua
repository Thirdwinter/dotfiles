vim.o.statuscolumn = [[%!v:lua.require'custom.Snacks.co'.get()]]
return {
  require("custom.DropBar"),
  --INFO: disable diagnostic using tiny-inline-diagnostic
  require 'custom.Lang.diagnostic',
  --INFO: lsp 相关的自动命令和键位映射
  require 'custom.Lang.lspAttach',
  require 'custom.resession'
}
