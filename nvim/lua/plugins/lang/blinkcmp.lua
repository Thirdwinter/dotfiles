if vim.g.cmpUsed ~= 'blink' then
  return {}
end

-- local max = math.ceil(vim.api.nvim_win_get_width(0) * 0.55)
return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip',
  },
  build = 'cargo build --release',

  -- use a release tag to download pre-built binaries
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    signature = { enabled = true },
    keymap = {
      preset = 'none',
      ['<C-e>'] = { 'show', 'hide' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-j>'] = { 'select_and_accept' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },
    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿 ',
        Method = '󰆧 ',
        Function = 'F ',
        Constructor = ' ',
        Field = '󰜢 ',
        Variable = '󰀫 ',
        Property = '󰜢 ',
        Class = '󰠱 ',
        Interface = ' ',
        Struct = '󰙅 ',
        Module = ' ',
        Unit = '󰑭 ',
        Value = '󰎠 ',
        Enum = ' ',
        EnumMember = ' ',
        Keyword = '󰌋 ',
        Constant = '󰏿 ',
        Snippet = ' ',
        Color = '󰏘 ',
        File = '󰈙 ',
        Reference = '󰈇 ',
        Folder = '󰉋 ',
        Event = ' ',
        Operator = '󰆕 ',
        TypeParameter = '󰬛 ',
      },
    },
    completion = {
      keyword = { range = 'full' },
      -- NOTE: some LSPs may add auto brackets themselves anyway
      accept = { auto_brackets = { enabled = true } },
      menu = {
        scrollbar = false,
        border = vim.g.borderStyle,
        -- auto_show = true,
        auto_show = function(ctx)
          -- 判断是否是命令行模式
          local is_cmdline_mode = ctx.mode == 'cmdline'
          -- 判断命令行类型是否为搜索命令（/ 或 ?）
          local is_search_cmd = vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())

          -- 返回 false 当处于命令行模式或搜索模式
          return not (is_cmdline_mode or is_search_cmd)
        end,
        draw = {
          align_to = 'none',
          columns = {
            { 'kind_icon', gap = 1, 'kind' },
            { 'label', 'label_description', gap = 1 },
          },
          components = {
            label = {
              width = { fill = true, max = 40 },
              text = function(ctx)
                local highlights_info = require('colorful-menu').blink_highlights(ctx)
                if highlights_info ~= nil then
                  -- Or you want to add more item to label
                  return highlights_info.label
                else
                  return ctx.label
                end
              end,
              highlight = function(ctx)
                local highlights = {}
                local highlights_info = require('colorful-menu').blink_highlights(ctx)
                if highlights_info ~= nil then
                  highlights = highlights_info.highlights
                end
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end
                -- Do something else
                return highlights
              end,
            },
          },
        },
      },

      -- Show documentation when selecting a completion item
      documentation = {
        window = {
          border = vim.g.borderStyle,
        },
        auto_show = true,
        auto_show_delay_ms = 100,
      },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = false },
    },
    sources = {
      default = { 'snippets', 'lsp', 'path', 'buffer', 'lazydev' },
      cmdline = {},
      providers = {
        lsp = {
          name = 'LSP',
          fallbacks = {
            'lazydev',
          },
        },
        lazydev = {
          name = 'Development',
          module = 'lazydev.integrations.blink',
        },
      },
    },
  },
  -- opts_extend = { 'sources.default' },
}
