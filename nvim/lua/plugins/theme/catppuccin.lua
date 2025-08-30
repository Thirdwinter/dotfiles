-- local color_overrides = {}
-- if vim.g.useMatugenCatppuccinColors then
--   local status, color = pcall(dofile, vim.fn.stdpath 'cache' .. '/matugen_catppuccin_colors.lua')
--   color_overrides = status and color or {}
-- else
--   color_overrides = {}
-- end
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    term_colors = true,
    transparent_background = not vim.g.neovide,
    float = {
      transparent = true, -- enable transparent floating windows
      solid = false,      -- use solid styling for floating windows, see |winborder|
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
        picker_style = 'classic', ---@type 'classic'|'nvchad' | 'nvchad_outlined'
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
      keywords = { 'italic' },
      strings = {},
      variables = {},
      numbers = {},
      booleans = { 'italic' },
      properties = {},
      types = {},
      operators = {},
    },
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

    color_overrides = {
      mocha = {
        -- rosewater = '#FB4834',
        -- flamingo = '#FB4834',
        -- red = '#FB4834',
        -- maroon = '#FB4834',
        pink = '#d3859b',
        mauve = '#d3859b',
        peach = '#e78a4e',
        yellow = '#FBBD2E',
        green = '#8dc07c',
        teal = '#FFCCCC',
        sky = '#99c792',
        sapphire = '#99c792',
        blue = '#8dbba3',
        lavender = '#8dbba3',
        text = '#f1e4c2',
        subtext2 = '#c5b4a1',
        subtext1 = '#d5c4a1',
        subtext0 = '#bdae93',
        overlay2 = '#a89984',
        overlay1 = '#928374',
        overlay0 = '#595959',
        surface2 = '#4d4d4d',
        surface1 = '#404040',
        surface0 = '#292929',
        base = '#1e1e2e',
        mantle = '#1d2224',
        crust = '#1f2223',
      },
      frappe = {
        rosewater = '#eb7a73',
        flamingo = '#eb7a73',
        red = '#eb7a73',
        maroon = '#eb7a73',
        pink = '#e396a4',
        mauve = '#e396a4',
        peach = '#e89a5e',
        yellow = '#E7B84C',
        green = '#7cb66a',
        teal = '#99c792',
        sky = '#99c792',
        sapphire = '#99c792',
        blue = '#8dbba3',
        lavender = '#8dbba3',
        text = '#f1e4c2',
        subtext1 = '#e5d5b1',
        subtext0 = '#c5bda3',
        overlay2 = '#b8a994',
        overlay1 = '#a39284',
        overlay0 = '#656565',
        surface2 = '#5d5d5d',
        surface1 = '#505050',
        surface0 = '#393939',
        base = '#1d2224',
        mantle = '#1d2224',
        crust = '#1f2223',
      },
    },
    custom_highlights = function(color)
      return {
        MsgSeparator = { bg = color.mantle },

        -- TabLine = { bg = color.surface0, fg = color.subtext0 },
        -- TabLineFill = { fg = color.subtext0, bg = color.mantle },
        -- TabLineSel = { fg = color.base, bg = color.overlay1 },

        MatchParen = { fg = 'NONE', bg = color.surface1, style = { 'bold' } },

        -- telescope overrides
        TelescopeTitle = { fg = color.base, bg = color.blue },
        TelescopePreviewTitle = { fg = color.base, bg = color.green },
        TelescopePromptTitle = { fg = color.base, bg = color.red },
        TelescopeResultsTitle = { fg = color.mantle, bg = color.lavender },

        -- window_picker overrides
        WindowPickerStatusLine = { fg = color.surface0, bg = color.red, style = { 'bold' } },
        WindowPickerStatusLineNC = { fg = color.surface0, bg = color.red, style = { 'bold' } },
        WindowPickerWinBar = { fg = color.surface0, bg = color.red, style = { 'bold' } },
        WindowPickerWinBarNC = { fg = color.surface0, bg = color.red, style = { 'bold' } },

        -- Normal float windows
        FloatBorder = { fg = color.lavender, bg = 'NONE' },
        NormalFloat = { fg = 'NONE', bg = 'NONE' },
        FloatTitle = { fg = color.sky, bg = 'NONE' },
      }
    end,
  },
}
