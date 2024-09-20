return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.cmdheight = 0

    -- Make sure to load noice when notify is called
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(...)
      require('noice').notify(...)
    end
  end,
  version = '4.4.7', -- Make sure to update this to something recent!
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },

  opts = {
    presets = {
      long_message_to_split = true,
      command_palette = true, -- position the cmdline and popupmenu together
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
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
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      progress = {
        enabled = false,
      },
      message = {
        enabled = false,
      },
      hover = {
        silent = true,
      },
    },
    views = {
      cmdline_popup = {
        border = {
          style = 'rounded',
        },
      },
      hover = {
        size = {
          max_width = 40,
        },
        border = {
          style = 'rounded',
          padding = { 0, 'rounded' == 'none' and 2 or 0 },
        },
        position = {
          row = 'rounded' == 'none' and 1 or 2,
        },
      },
      mini = {
        win_options = {
          winblend = 0,
        },
      },
    },
  },
}
