-- if true then
--   return {}
-- end
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.cmdheight = 0
  end,
  -- version = '4.4.7', -- Make sure to update this to something recent!
  dependencies = {
    'MunifTanjim/nui.nvim',
    -- 'rcarriga/nvim-notify',
  },
  opts = {
    presets = {
      long_message_to_split = true,
      command_palette = false, -- position the cmdline and popupmenu together
      inc_rename = true,       -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,  -- add a border to hover docs and signature help
    },
    cmdline = {
      format = {
        search_down = {
          view = 'cmdline',
        },
        search_up = {
          view = 'cmdline',
        },
        substitute = {
          pattern = {
            '^:%s*%%s?n?o?m?/',
            "^:'<,'>%s*s?n?m?/",
            '^:%d+,%d+%s*s?n?m?/',
          },
          icon = ' /',
          view = 'cmdline',
          lang = 'regex',
        },
      },
    },

    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,              -- enables the Noice messages UI
      view = 'notify',             -- default view for messages
      view_error = 'notify',       -- view for errors
      view_warn = 'notify',        -- view for warnings
      view_history = 'messages',   -- view for :messages
      view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
    },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
        ['vim.lsp.util.stylize_markdown'] = false,
        ['cmp.entry.get_documentation'] = false,
      },
      progress = {
        enabled = true,
        view = 'mini',
      },
      message = {
        enabled = true,
      },
      hover = {
        enabled = true,
        silent = true,
      },
      signature = {
        enabled = false,
      },
      documentation = {
        view = 'hover',
        opts = {
          lang = 'plaintext',
          replace = false,
          render = 'plain',
          format = { '{message}' },
        },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
        border = {
          style = vim.g.borderStyle,
        },
        win_options = {
          -- winhighlight = { Normal = 'Normal', FloatBorder = 'FloatBorder' },
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 8,
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = vim.g.borderStyle,
          padding = { 0, 1 },
        },
        win_options = {
          -- winhighlight = { Normal = 'Normal', FloatBorder = 'FloatBorder' },
        },
      },
      hover = {
        -- relative = 'editor',
        -- position = {
        --   row = 8,
        --   col = '50%',
        -- },

        position = { row = 2 },

        scrollbar = false,
        size = {
          max_width = math.ceil(vim.api.nvim_win_get_width(0) * 0.4),
        },
        border = {
          style = vim.g.borderStyle,
        },
        win_options = {
          -- winhighlight = { Normal = 'Normal', FloatBorder = 'FloatBorder' },
        },
      },
      mini = {
        border = {
          style = vim.g.borderStyle,
        },

        position = {
          row = -2,
          col = '100%',
        },
        win_options = {
          -- winhighlight = { Normal = 'Label', FloatBorder = 'FloatBorder' },
          winblend = 0,
        },
      },
    },
  },
}
