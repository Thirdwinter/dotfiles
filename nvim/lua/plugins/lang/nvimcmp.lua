---@diagnostic disable: undefined-global
if vim.g.cmpUsed ~= 'cmp' then
  return {}
end
local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end
local function is_visible(cmp)
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    vim.api.nvim_set_hl(0, 'CmpCursorLine', { bg = '#a6e3a1', fg = '#1e1e2e', bold = true })
    luasnip.config.setup {}
    require('lspkind').init {
      mode = 'symbol_text',
      preset = 'codicons',
      symbol_map = {
        Text = '󰉿 ',
        Method = '󰆧 ',
        Function = '󰊕 ',
        Constructor = ' ',
        Field = '󰜢 ',
        Variable = '󰀫 ',
        Class = '󰠱 ',
        Interface = ' ',
        Module = ' ',
        Property = '󰜢 ',
        Unit = '󰑭 ',
        Value = '󰎠 ',
        Enum = ' ',
        Keyword = '󰌋 ',
        Snippet = ' ',
        Color = '󰏘 ',
        File = '󰈙 ',
        Reference = '󰈇 ',
        Folder = '󰉋 ',
        EnumMember = ' ',
        Constant = '󰏿 ',
        Struct = '󰙅 ',
        Event = ' ',
        Operator = '󰆕 ',
        TypeParameter = '󰬛 ',
      },
    }
    cmp.setup {
      formatting = {
        format = require('lspkind').cmp_format {
          maxwidth = 25,
          ellipsis_char = '',
          menu = {
            path = '[PATH]',
            buffer = '[BUF]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[LUA]',
            luasnip = '[SNIP]',
          },
        },
        expandable_indicator = true,
        fields = { 'kind', 'abbr', 'menu' },
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      window = {
        completion = {
          border = vim.g.borderStyle,
          scrollbar = false,
          col_offset = -3,
          winhighlight = 'CursorLine:CmpCursorLine',
        },
        documentation = cmp.config.window.bordered {
          winhighlight = 'CursorLine:CmpCursorLine',
          border = vim.g.borderStyle,
        },
        -- documentation = {
        --   border = 'rounded',
        -- },
      },

      mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<c-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select, count = 1 },
        ['<c-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select, count = 1 },
        ['<c-j>'] = cmp.mapping.confirm { select = true },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select, count = 1 }
          elseif vim.api.nvim_get_mode().mode ~= 'c' and luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select, count = 1 }
          elseif vim.api.nvim_get_mode().mode ~= 'c' and luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      sources = {
        { name = 'luasnip', priority = 1000 },
        { name = 'nvim_lsp', priority = 800 },
        { name = 'path', priority = 600 },
        {
          name = 'buffer',
          option = {
            get_bufnrs = function()
              local buf = vim.api.nvim_get_current_buf()
              local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              if byte_size > 1024 * 1024 then -- 1 Megabyte max
                return {}
              end
              return { buf }
            end,
          },
          priority = 400,
        },
        {
          name = 'lazydev',
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = 'nvim_lsp_signature_help' },
      },
    }
  end,
}
