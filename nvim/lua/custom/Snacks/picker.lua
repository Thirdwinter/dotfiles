local M = {}
M.options = {
  ui_select = false,
  layout = {
    reverse = true,
    layout = {
      box = 'horizontal',
      backdrop = false,
      width = 0.9,
      height = 0.9,
      border = 'none',
      {
        box = 'vertical',
        { win = 'list', title = ' Results ', title_pos = 'center', border = vim.g.borderStyle },
        { win = 'input', height = 1, border = vim.g.borderStyle, title = '{title} {live} {flags}', title_pos = 'center' },
      },
      {
        win = 'preview',
        title = '{preview:Preview}',
        width = 0.65,
        border = vim.g.borderStyle,
        title_pos = 'center',
      },
    },
  },
  win = {
    input = {
      keys = { ['<a-a>'] = 'cycle_win', mode = { 'i', 'n' } },
    },
    list = {
      keys = { ['<a-a>'] = 'cycle_win' },
    },
    preview = {
      keys = {
        ['<Esc>'] = 'close',
        ['q'] = 'close',
        ['i'] = 'focus_input',
        ['<ScrollWheelDown>'] = 'list_scroll_wheel_down',
        ['<ScrollWheelUp>'] = 'list_scroll_wheel_up',
        ['<a-a>'] = 'cycle_win',
      },
    },
  },
}
M.keys = {
  {
    '<leader><space>',
    function()
      Snacks.picker.smart()
    end,
    desc = 'Smart Find Files',
  },
  {
    '<F8>',
    function()
      Snacks.picker.smart()
    end,
    desc = 'Smart Find Files',
    mode = { 'n', 'i', 't' },
  },
  {
    '<leader>ft',
    function()
      Snacks.picker.colorschemes()
    end,
    desc = 'Colorschemes',
  },
  {
    '<leader>fc',
    function()
      Snacks.picker.cliphist {
        -- layout = {
        --   layout = {
        --     box = 'vertical',
        --     backdrop = false,
        --     row = -1,
        --     width = 0,
        --     height = 0.4,
        --     border = 'top',
        --     title = ' {title} {live} {flags}',
        --     title_pos = 'left',
        --     { win = 'input', height = 1, border = 'bottom' },
        --     {
        --       box = 'horizontal',
        --       { win = 'list', border = 'none' },
        --       { win = 'preview', title = '{preview}', width = 0.6, border = 'left' },
        --     },
        --   },
        -- },
      }
    end,
    desc = 'Cliphist',
  },
  {
    '<leader>fh',
    function()
      Snacks.picker.help()
    end,
    desc = 'Help Pages',
  },
  {
    '<leader>fn',
    function()
      Snacks.picker.smart { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Smart Find Nvim Config',
  },
  {
    '<leader>fk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    '<leader>ff',
    function()
      Snacks.picker.smart()
    end,
    desc = 'Smart Find Files',
  },
  {
    '<leader>fb',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Buffers',
  },
  {
    '<leader>fl',
    function()
      Snacks.picker.lines()
    end,
    desc = 'Buffer Lines',
  },
  {
    '<leader>fg',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Grep',
  },
  {
    '<leader>fw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = 'Visual selection or word',
    mode = { 'n', 'x' },
  },
  {
    '<leader>fB',
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = 'Grep Open Buffers',
  },
  {
    '<leader>f.',
    function()
      Snacks.picker.resume()
    end,
    desc = 'Resume',
  },
  {
    '<leader>fr',
    function()
      Snacks.picker.recent()
    end,
    desc = 'Recent',
  },
  {
    '<leader>fD',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = 'Diagnostics',
  },
  {
    '<leader>fd',
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = 'Buffer Diagnostics',
  },
  {
    '<leader>fo',
    function()
      Snacks.picker.noice {
        -- layout = {
        --   layout = {
        --     box = 'vertical',
        --     backdrop = false,
        --     row = -1,
        --     width = 0,
        --     height = 0.4,
        --     border = 'top',
        --     title = ' {title} {live} {flags}',
        --     title_pos = 'left',
        --     { win = 'input', height = 1, border = 'bottom' },
        --     {
        --       box = 'horizontal',
        --       { win = 'list', border = 'none' },
        --       { win = 'preview', title = '{preview}', width = 0.6, border = 'left' },
        --     },
        --   },
        -- },
      }
    end,
    desc = '[F]ind [O]ld [N]otifications',
  },

  {
    '<leader>fu',
    function()
      Snacks.picker.undo()
    end,
    desc = '[F]ind [U]ndo',
  },
  {
    '<leader>fa',
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients { bufnr = bufnr }
      local function has_lsp_symbols()
        for _, client in ipairs(clients) do
          if client.server_capabilities.documentSymbolProvider then
            return true
          end
        end
        return false
      end

      local picker_opts = {
        layout = 'right',
        tree = true,
        on_show = function()
          vim.cmd.stopinsert()
        end,
      }
      if has_lsp_symbols() then
        Snacks.picker.lsp_symbols(picker_opts)
      else
        Snacks.picker.treesitter()
      end
    end,
    desc = 'LSP Symbols',
  },
}
return M
