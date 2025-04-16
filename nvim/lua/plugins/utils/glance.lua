return {
  'dnlhc/glance.nvim',
  lazy = true,
  cmd = {
    'Glance',
  },
  config = function()
    local glance = require 'glance'
    local actions = glance.actions

    glance.setup {
      height = 36,
      theme = {
        enable = true,
        mode = 'darken',
      },
      mappings = {
        list = {
          ['gp'] = actions.enter_win 'preview',
        },
        preview = {
          ['gp'] = actions.enter_win 'list',
          ['Q'] = actions.close,
        },
      },
      folds = {
        folded = false,
      },
      border = {
        enable = true,
      },
      use_trouble_qf = true,
    }
  end,
}
