return {
  priority = 1,
  enabled = true, -- enable indent guides
  char = '│',
  only_scope = false, -- only show indent guides of the scope
  only_current = false, -- only show indent guides in the current window
  hl = 'SnacksIndent', ---@type string|string[] hl groups for indent guides
  animate = {
    enabled = vim.fn.has 'nvim-0.10' == 1,
    style = 'up_down',
    easing = 'linear',
    duration = {
      step = 20, -- ms per step
      total = 500, -- maximum duration
    },
  },
  scope = {
    enabled = true, -- enable highlighting the current scope
    priority = 200,
    char = '┋',
    underline = false, -- underline the start of the scope
    only_current = false, -- only show scope in the current window
    hl = {
      'SnacksIndent1',
      'SnacksIndent2',
      'SnacksIndent3',
      'SnacksIndent4',
      'SnacksIndent5',
      'SnacksIndent6',
      'SnacksIndent7',
      'SnacksIndent8',
    },
  },
  chunk = {
    -- when enabled, scopes will be rendered as chunks, except for the
    -- top-level scope which will be rendered as a scope.
    enabled = true,
    -- only show chunk scopes in the current window
    only_current = false,
    priority = 200,
    hl = 'SnacksIndentChunk', ---@type string|string[] hl group for chunk scopes
    char = {
      corner_top = '┌',
      corner_bottom = '└',
      -- corner_top = '╭',
      -- corner_bottom = '╰',
      horizontal = '─',
      vertical = '│',
      arrow = '>',
    },
  },
  blank = {
    char = ' ',
    -- char = "·",
    hl = 'SnacksIndentBlank', ---@type string|string[] hl group for blank spaces
  },
  -- filter for buffers to enable indent guides
  filter = function(buf)
    return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ''
  end,
}
