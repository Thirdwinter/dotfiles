local max = vim.api.nvim_win_get_width(0)

return function(_, opts)
  vim.cmd 'highlight link BlinkCmpMenuBorder FloatBorder'
  vim.cmd 'highlight link BlinkCmpDocBorder FloatBorder'
  vim.cmd 'highlight link BlinkCmpSignatureHelpBorder FloatBorder'

  opts.signature = {
    enabled = true,
    window = {
      border = vim.g.borderStyle,
    },
  }
  opts.cmdline = {
    enabled = false,
  }
  opts.keymap = {
    preset = 'none',
    ['<C-i>'] = { 'show', 'hide', 'fallback' },
    ['<C-->'] = { 'hide_documentation', 'show_documentation', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
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
    ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  }
  -- opts.snippets = {
  --   preset = 'luasnip',
  -- }
  opts.appearance = {
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
  }
  opts.completion = {
    list = {
      cycle = { from_bottom = false, from_top = false },
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    keyword = { range = 'full' },
    -- NOTE: some LSPs may add auto brackets themselves anyway
    accept = {
      auto_brackets = {
        -- Whether to auto-insert brackets for functions
        enabled = true,
        -- Default brackets to use for unknown languages
        default_brackets = { '(', ')' },
        -- Overrides the default blocked filetypes
        override_brackets_for_filetypes = {},
        -- Synchronously use the kind of the item to determine if brackets should be added
        kind_resolution = {
          enabled = true,
          blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue' },
        },
      },
    },
    menu = {
      scrollbar = false,
      border = vim.g.borderStyle,
      auto_show = true,
      draw = {
        align_to = 'cursor',
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
      auto_show = true,
      auto_show_delay_ms = 500,
    },

    -- Display a preview of the selected item on the current line
    ghost_text = { enabled = false },
  }
  opts.sources = {
    -- default = { 'snippets', 'lsp', 'path', 'buffer' },
    -- providers = {
    --   snippets = { score_offset = 1000 },
    -- },

    default = { 'snippets', 'lsp', 'path', 'buffer', 'lazydev', 'markdown' },

    providers = {
      lsp = {},
      snippets = {},
      lazydev = {
        name = 'Development',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      markdown = {
        name = 'RenderMarkdown',
        module = 'render-markdown.integ.blink',
        fallbacks = { 'lsp' },
      },
    },
  }
  opts.fuzzy = { implementation = 'prefer_rust_with_warning' }
  -- opts.opts_extend = { 'sources.default' }
end
