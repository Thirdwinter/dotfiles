--INFO: 光标轨迹
return {
  'LeonHeidelbach/trailblazer.nvim',
  event = 'VeryLazy',
  -- opts = {},
  config = function()
    --     -- your custom config goes here
    require('trailblazer').setup {}
    -- 创建一个 autocommand 组，确保不会重复定义
    -- vim.api.nvim_create_augroup('SearchJumpGroup', { clear = true })
    --
    -- -- 在搜索模式跳转前执行函数
    -- vim.api.nvim_create_autocmd('CmdlineLeave', {
    --   group = 'SearchJumpGroup',
    --   pattern = '[/?]', -- 仅在搜索模式下触发
    --   callback = function()
    --     -- 检查是否是搜索模式，并且搜索命令不为空
    --     if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    --       vim.cmd 'TrailBlazerNewTrailMark'
    --     end
    --   end,
    -- })
  end,
}
