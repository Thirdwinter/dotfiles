local color_overrides = {}
if vim.g.useMatugenCatppuccinColors then
  local status, color = pcall(dofile, vim.fn.stdpath 'cache' .. '/matugen_catppuccin_colors.lua')
  color_overrides = status and color or {}
else
  color_overrides = {}
end
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    term_colors = true,
    transparent_background = not vim.g.neovide,
    float = {
      transparent = true, -- enable transparent floating windows
      solid = true,       -- use solid styling for floating windows, see |winborder|
    },
    integrations = {
      cmp = true,
      blink_cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = true,
      mason = true,
      rainbow_delimiters = true,
      snacks = {
        enabled = true,
        picker_style = "classic" ---@type 'classic'|'nvchad' | 'nvchad_outlined'
      },
      mini = {
        enabled = true,
        -- indentscope_color = '',
      },
      dropbar = {
        enabled = true,
        color_mode = true, -- enable color for kind's texts, not just kind's icons
      },
      fidget = true,
      noice = true,
      symbols_outline = true,
      lsp_trouble = true,
      which_key = true,
    },
    -- transparent_background = transparent_background,
    styles = {                 -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { 'italic' }, -- Change the style of comments
      conditionals = { 'italic' },
      loops = {},
      functions = { 'italic' },
      keywords = { 'italic', 'bold' },
      strings = {},
      variables = {},
      numbers = {},
      booleans = { 'italic' },
      properties = {},
      types = {},
      operators = {},
    },
    -- color_overrides = color_overrides,
    highlight_overrides = {
      mocha = function(mocha)
        return {
          DiagnosticUnderlineError = { undercurl = true, sp = mocha.red },
          DiagnosticUnderlineWarn = { undercurl = true, sp = mocha.yellow },
          DiagnosticUnderlineInfo = { undercurl = true, sp = mocha.green },
          DiagnosticUnderlineHint = { undercurl = true, sp = mocha.sky },
        }
      end,
    },
  },
}
