--INFO: treesitter ensure_installed
local ensure_installed = {
  'lua',
  'vim',
  'go',
  'rust',
  'c',
  'python',
  'json',
  'yaml',
  'ini',
  'toml',
  'markdown',
}
return { -- 高亮显示、编辑和导航代码
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- 设置用于 opts 的主模块
  -- [[配置 Treesitter]] 参见 `:help nvim-treesitter`
  config = function()
    require('nvim-treesitter.configs').setup {
      modules = {},
      ensure_installed = ensure_installed,
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      -- List of parsers to ignore installing (for "all")
      ignore_install = { 'tmux' },
      -- 支持的语言
      -- 启用代码高亮
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      --启用增量选择
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
          scope_incremental = '<TAB>',
        },
      },
      -- 启用基于 Treesitter 的代码格式化(=)
      indent = {
        enable = false,
      },
    }
    -- -- 开启代码折叠
    -- vim.wo.foldmethod = 'expr'
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- 默认不折叠
    -- vim.wo.foldlevel = 99
  end,

  -- 有额外的 nvim-treesitter 模块可以用来与 nvim-treesitter 交互。
  -- 你应该去探索一些，看看哪些是你感兴趣的：
  --
  --    - 增量选择：已包含，参见 `:help nvim-treesitter-incremental-selection-mod`
  --    - 显示你当前的上下文：https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + 文本对象：https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
