local M = {}
M.options = {
  sources = {
    explorer = {
      layout = {
        preview = 'main',
        reverse = false,

        layout = {
          backdrop = false,
          width = 40,
          min_width = 40,
          height = 0,
          position = 'left',
          border = 'none',
          box = 'vertical',
          {
            win = 'input',
            height = 1,
            border = vim.g.borderStyle,
            title = '{title} {live} {flags}',
            title_pos = 'center',
          },
          { win = 'list', border = 'none' },
          -- { win = 'preview', title = '{preview}', height = 0.2, border = 'top' },
        },
      },
      -- your explorer picker configuration comes here
      -- or leave it empty to use the default settings
    },
    select = {
      layout = {
        layout = {
          reverse = false,
          min_height = 8,
          backdrop = false,
          width = 0.7,
          height = 0.9,
          border = 'none',
        },
      },
    },
  },
  ui_select = true,
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
        { win = 'list',  title = ' Results ', title_pos = 'center',       border = vim.g.borderStyle },
        { win = 'input', height = 1,          border = vim.g.borderStyle, title = '{title} {live} {flags}', title_pos = 'center' },
      },
      {
        win = 'preview',
        title = '{preview:Preview}',
        width = 0.7,
        border = vim.g.borderStyle,
        title_pos = 'center',
      },
    },
  },

  win = {
    input = {
      keys = {
        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
        ['<a-a>'] = {
          'cycle_win',
          mode = { 'i', 'n' }
        }
      },
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
      Snacks.picker.cliphist {}
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
      Snacks.picker.notifications {}
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
