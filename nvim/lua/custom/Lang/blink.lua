local max = vim.api.nvim_win_get_width(0)

return {
  signature = {
    enabled = true,
    window = {
      border = vim.g.borderStyle,
    },
  },
  keymap = {
    cmdline = {
      preset = 'none',
      ['<Tab>'] = {
        function(cmp)
          local is_search_cmd = vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          if is_search_cmd then
            cmp.accept {
              callback = function()
                vim.api.nvim_feedkeys('\n', 'n', true)
              end,
            }
          else
            cmp.accept()
          end
        end,
      },
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<C-e>'] = { 'show', 'hide' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
    },
    preset = 'none',
    ['<C-i>'] = { 'show', 'hide' },
    ['<C-->'] = { 'hide_documentation', 'show_documentation' },
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
    preset = 'luasnip',
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
    kind_icons = {
      Text = '󰉿 ',
      Method = '󰆧 ',
      Function = '󰊕 ',
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
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    keyword = { range = 'full' },
    -- NOTE: some LSPs may add auto brackets themselves anyway
    accept = { auto_brackets = { enabled = true } },
    menu = {
      scrollbar = false,
      border = vim.g.borderStyle,
      auto_show = true,
      -- auto_show = function(ctx)
      --   -- 判断是否是命令行模式
      --   ---@diagnostic disable-next-line: unused-local
      --   local is_cmdline_mode = ctx.mode == 'cmdline'
      --   -- 判断命令行类型是否为搜索命令（/ 或 ?）
      --   local is_search_cmd = vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
      --
      --   -- 返回 false 当处于命令行模式或搜索模式
      --   return not is_search_cmd
      -- end,
      draw = {
        align_to = 'none',
        columns = {
          { 'kind_icon', 'label' },
          { 'kind' },
        },
        components = {
          label = {
            width = { fill = true, max = math.ceil(max * 0.25) },
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
          kind = {
            ellipsis = true,
            width = { fill = false },
          },
          label_description = {
            width = { max = 10 },
            text = function(ctx)
              return ctx.label_description
            end,
            highlight = 'BlinkCmpLabelDescription',
          },
        },
      },
    },

    -- Show documentation when selecting a completion item
    documentation = {
      window = {
        max_width = math.ceil(max * 0.6),
        max_height = 10,
        border = vim.g.borderStyle,
        scrollbar = false,
      },
      auto_show = false,
      auto_show_delay_ms = 100,
    },

    -- Display a preview of the selected item on the current line
    ghost_text = { enabled = false },
  },
  sources = {
    default = { 'snippets', 'lsp', 'path', 'buffer', 'lazydev' },
    -- cmdline = {},
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
}
