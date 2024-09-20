-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim', -- 插件名称，表示要配置的是 gitsigns.nvim 插件
    event = 'VeryLazy',
    opts = { -- 插件的配置选项
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '┃' },
        topdelete = { text = '┃' },
        changedelete = { text = '┃' },
      },
      on_attach = function(bufnr) -- 当插件加载到缓冲区时执行的函数
        local gitsigns = require 'gitsigns' -- 引入 gitsigns 模块

        local function map(mode, l, r, opts) -- 定义一个函数用于映射键位
          opts = opts or {} -- 如果没有提供 opts，则设置为空表
          opts.buffer = bufnr -- 设置映射的缓冲区
          vim.keymap.set(mode, l, r, opts) -- 执行键位映射
        end

        -- Navigation: 导航
        map('n', ']c', function() -- 定义导航到下一个更改块的快捷键
          if vim.wo.diff then -- 如果当前处于 diff 模式
            vim.cmd.normal { ']c', bang = true } -- 执行 diff 模式下的跳转命令
          else
            gitsigns.nav_hunk 'next' -- 否则，使用 gitsigns 导航到下一个更改块
          end
        end, { desc = 'Jump to next git [c]hange' }) -- 快捷键描述

        map('n', '[c', function() -- 定义导航到上一个更改块的快捷键
          if vim.wo.diff then -- 如果当前处于 diff 模式
            vim.cmd.normal { '[c', bang = true } -- 执行 diff 模式下的跳转命令
          else
            gitsigns.nav_hunk 'prev' -- 否则，使用 gitsigns 导航到上一个更改块
          end
        end, { desc = 'Jump to previous git [c]hange' }) -- 快捷键描述

        -- Actions: 操作
        -- visual mode: 可视模式下的快捷键
        map('v', '<leader>gs', function() -- 可视模式下，使用 <leader>hs 快捷键来暂存更改块
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } -- 暂存当前可视选择的更改块
        end, { desc = '[S]tage git hunk' }) -- 快捷键描述
        map('v', '<leader>gr', function() -- 可视模式下，使用 <leader>hr 快捷键来重置更改块
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } -- 重置当前可视选择的更改块
        end, { desc = '[R]eset git hunk' }) -- 快捷键描述

        -- normal mode: 普通模式下的快捷键
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' }) -- 普通模式下，使用 <leader>hs 快捷键来暂存更改块
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' }) -- 普通模式下，使用 <leader>hr 快捷键来重置更改块
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' }) -- 普通模式下，使用 <leader>hS 快捷键来暂存整个缓冲区
        map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' }) -- 普通模式下，使用 <leader>hu 快捷键来撤销暂存的更改块
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' }) -- 普通模式下，使用 <leader>hR 快捷键来重置整个缓冲区
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' }) -- 普通模式下，使用 <leader>hp 快捷键来预览更改块
        map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git [b]lame line' }) -- 普通模式下，使用 <leader>hb 快捷键来查看当前行的 blame 信息
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' }) -- 普通模式下，使用 <leader>hd 快捷键来与索引进行 diff 比较
        map('n', '<leader>gD', function() -- 普通模式下，使用 <leader>hD 快捷键来与最后一次提交进行 diff 比较
          gitsigns.diffthis '@' -- 使用 '@' 符号表示最后一次提交
        end, { desc = 'git [D]iff against last commit' }) -- 快捷键描述

        -- Toggles: 切换
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' }) -- 普通模式下，使用 <leader>tb 快捷键来切换当前行的 blame 信息显示
        map('n', '<leader>gtD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' }) -- 普通模式下，使用 <leader>tD 快捷键来切换显示已删除的行
      end,
    },
  },
}
