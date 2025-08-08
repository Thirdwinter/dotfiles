return {
  'echasnovski/mini.files',
  -- event = 'VeryLazy',
  version = false,
  opts = function(_, opts)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesWindowOpen',
      callback = function(args)
        local win_id = args.data.win_id
        -- Customize window-local settings
        vim.wo[win_id].winblend = 0
        local config = vim.api.nvim_win_get_config(win_id)
        config.border, config.title_pos = vim.g.borderStyle, 'left'
        vim.api.nvim_win_set_config(win_id, config)
      end,
    })

    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'MiniFilesWindowUpdate',
    --   callback = function(args)
    --     local config = vim.api.nvim_win_get_config(args.data.win_id)
    --
    --     -- Ensure fixed height
    --     config.height = 15
    --
    --     -- Ensure no title padding
    --     local n = #config.title
    --     config.title[1][1] = config.title[1][1]:gsub('^ ', '')
    --     config.title[n][1] = config.title[n][1]:gsub(' $', '')
    --
    --     vim.api.nvim_win_set_config(args.data.win_id, config)
    --   end,
    -- })
    opts.option = {
      use_as_default_explorer = false,
    }
    opts.windows = {
      preview = false,
      width_preview = 40,
    }
    opts.mappings = {
      close = 'q',
      go_in = 'l',
      go_in_plus = 'L',
      go_out = 'h',
      go_out_plus = 'H',
      mark_goto = "'",
      mark_set = 'm',
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '=',
      trim_left = '<',
      trim_right = '>',
    }
    vim.keymap.set('n', '<leader>o', function()
      if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end
    end, { desc = "open mini.files" })
  end,
}
