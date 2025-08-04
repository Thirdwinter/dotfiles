return {

  cmd = { 'lua-language-server', '--locale=zh-cn' },
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      completion = {
        autoRequire = false,
        callSnippet = 'Replace',
      },
    },
  },
}
