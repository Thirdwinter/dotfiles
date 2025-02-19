-- 模糊查找器（文件，lsp 等）
return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  -- branch = '0.1.x',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- 如果遇到错误，请参见 telescope-fzf-native README 安装说明
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` 用于在插件安装/更新时运行某些命令。
      -- 这只在那时运行，不是每次 Neovim 启动时都运行。
      build = 'make',

      -- `cond` 是一个条件，用于确定是否应该安装和加载这个插件。
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- 对于获取漂亮的图标很有用，但需要 Nerd 字体。
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    'scottmckendry/telescope-resession.nvim',
  },
  config = function()
    local actions = require 'telescope.actions'

    -- Telescope 是一个模糊查找器，它附带了很多不同的可以模糊查找的东西！
    -- 它不仅仅是一个“文件查找器”，它可以搜索 Neovim、你的工作区、LSP 和更多方面的许多不同内容！
    --
    -- 使用 Telescope 最简单的方法是开始做一些像：
    --  :Telescope help_tags
    --
    -- 运行这个命令后，会打开一个窗口，你可以在提示窗口中输入。
    -- 你将看到 `help_tags` 选项的列表和相应的帮助预览。
    --
    -- 在 Telescope 中使用时，两个重要的键位映射是：
    --  - 插入模式：<c-/>
    --  - 普通模式：?
    --
    -- 这会打开一个窗口，显示当前 Telescope 选择器的所有键位映射。
    -- 这非常有助于发现 Telescope 能做什么以及如何实际做到！

    -- [[ 配置 Telescope ]]
    -- 参见 `:help telescope` 和 `:help telescope.setup()`
    require('telescope').setup {
      -- 你可以在这里放置你的默认映射/更新/等。
      -- 所有你正在寻找的信息都在 `:help telescope.setup()`
      --
      defaults = {
        mappings = {
          i = {
            ['<c-enter>'] = 'to_fuzzy_refine',
            ['<esc>'] = actions.close,
            ['jj'] = actions.close,
            ['<C-p>'] = {
              actions.move_selection_previous,
              type = 'action',
              opts = { nowait = true, silent = true },
            },
            ['<C-n>'] = {
              actions.move_selection_next,
              type = 'action',
              opts = { nowait = true, silent = true },
            },
            ['<C-k>'] = {
              actions.move_selection_previous,
              type = 'action',
              opts = { nowait = true, silent = true },
            },

            ['<C-j>'] = {
              actions.move_selection_next,
              type = 'action',
              opts = { nowait = true, silent = true },
            },
          },
        },
      },
      -- pickers = {}
      extensions = {
        resession = {
          prompt_title = 'Find Sessions', -- telescope prompt title
          dir = 'session', -- directory where resession stores sessions
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- 如果安装了 Telescope 扩展，则启用它们
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    -- 参见 `:help telescope.builtin`
    -- 参见 `:help telescope.builtin.live_grep()` 了解特定键的信息

    vim.keymap.set('n', '<F8>', '<Cmd>Telescope find_files<CR>', { desc = 'Open Telescope File Explorer', noremap = true, silent = true })
    vim.keymap.set('t', '<F8>', '<Cmd>Telescope find_files<CR>', { desc = 'Open Telescope File Explorer', noremap = true, silent = true })
    vim.keymap.set('i', '<F8>', '<Esc><Cmd>Telescope find_files<CR>', { desc = 'Open Telescope File Explorer', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fct', '<Cmd>Telescope colorscheme<CR>', { desc = '[F]ind [C]olorschemes', noremap = true, silent = true })
    vim.keymap.set(
      'n',
      '<Leader>fo',
      '<Cmd>lua require("telescope").extensions.notify.notify()<CR>',
      { desc = '[F]ind [O]ld [N]otifications', noremap = true, silent = true }
    )
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing buffers' })
    vim.keymap.set('n', '<leader>f/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[F]ind [/] in Open Files' })

    -- -- 搜索你的 Neovim 配置文件的快捷方式
    -- vim.keymap.set('n', '<leader>fn', function()
    --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
    -- end, { desc = '[F]ind [N]eovim files' })
  end,
}
