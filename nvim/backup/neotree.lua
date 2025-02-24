require('neo-tree').setup {
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on the left-hand side
      -- indent guides
      with_markers = true,
      indent_marker = '│',
      last_indent_marker = '└',
      highlight = 'NeoTreeIndentMarker',
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '󰜌',
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = '*',
      highlight = 'NeoTreeFileIcon',
    },
    modified = {
      symbol = '[+]',
      highlight = 'NeoTreeModified',
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = 'NeoTreeFileName',
    },
    git_status = {
      symbols = {
        -- Change type
        added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = '✖', -- this can only be used in the git_status source
        renamed = '', -- this can only be used in the git_status source
        -- Status type
        untracked = '',
        ignored = '◌',
        unstaged = '',
        staged = '',
        conflict = '',
      },
    },
    file_size = {
      enabled = true,
      required_width = 64, -- min width of window required to show this column
    },
    type = {
      enabled = true,
      required_width = 122, -- min width of window required to show this column
    },
    last_modified = {
      enabled = true,
      required_width = 88, -- min width of window required to show this column
    },
    created = {
      enabled = true,
      required_width = 110, -- min width of window required to show this column
    },
    symlink_target = {
      enabled = false,
    },
  },
  filesystem = {
    hijack_netrw_behavior = 'open_default', -- This ensures Neotree opens when using 'nvim .'
  },
  window = {
    position = 'left',
    width = 25,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ['<space>'] = {
        'toggle_node',
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      },
      ['<2-LeftMouse>'] = 'open',
      ['<cr>'] = 'open',
      ['l'] = 'open',
      ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
      ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
      ['S'] = 'open_split',
      ['s'] = 'open_vsplit',
      ['t'] = 'open_tabnew',
      ['w'] = 'open_with_window_picker',
      ['C'] = 'close_node',
      ['z'] = 'close_all_nodes',
      ['a'] = {
        'add',
        config = {
          show_path = 'none', -- "none", "relative", "absolute"
        },
      },
      ['A'] = 'add_directory',
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['y'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['c'] = 'copy',
      ['m'] = 'move',
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
      ['<'] = 'prev_source',
      ['>'] = 'next_source',
      ['i'] = 'show_file_details',
    },
  },
}
