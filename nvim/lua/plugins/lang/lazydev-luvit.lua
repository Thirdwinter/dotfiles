return {
  {
    -- `lazydev` 配置你的 Neovim 配置、运行时和插件的 Lua LSP
    -- 用于 Neovim API 的补全、注释和签名
    'folke/lazydev.nvim',
    evnet = 'VimEnter',
    ft = 'lua',
    opts = {
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'Lazy' } },
        -- 当发现 `vim.uv` 单词时，加载 luvit 类型
        { path = 'luvit-meta/library', words = { 'vim%.uv', 'vim%.loop' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
}
