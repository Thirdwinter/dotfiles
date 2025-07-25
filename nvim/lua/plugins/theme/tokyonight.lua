return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  -- init = function()
  --   -- Load the colorscheme here.
  --   -- Like many other themes, this one has different styles, and you could load
  --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --
  --   -- You can configure highlights by doing something like:
  --   vim.cmd.hi 'Comment gui=none'
  -- end,
  opts = {
    style = 'storm',
    transparent = true,
    terminal_colors = false,
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = true },
      variables = { italic = false },
      Booleam = { italic = true },
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = 'transparent', -- style for sidebars, see below
      floats = 'transparent',   -- style for floating windows
    },
    on_highlights = function(highlights, colors)
      highlights.WinBar = ''
      highlights.WinBarNC = ''
      highlights.TabLine = ''
      highlights.TabLineFill = ''
      highlights.StatusLine = ''
      highlights.StatusLineNC = ''
    end,
    plugins = {
      base = false,
    },
  },
}
