local function transparent_background_nd()
  if vim.g.neovide then
    return false
  end
  return true
end

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    term_colors = true,
    transparent_background = transparent_background_nd(),
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = true,
      mason = true,
      -- mini = {
      --   enabled = true,
      --   indentscope_color = '',
      -- },
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
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
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
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    -- custom_highlights = function(C)
    --   return {
    --     CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
    --     CmpItemKindKeyword = { fg = C.base, bg = C.red },
    --     CmpItemKindText = { fg = C.base, bg = C.teal },
    --     CmpItemKindMethod = { fg = C.base, bg = C.blue },
    --     CmpItemKindConstructor = { fg = C.base, bg = C.blue },
    --     CmpItemKindFunction = { fg = C.base, bg = C.blue },
    --     CmpItemKindFolder = { fg = C.base, bg = C.blue },
    --     CmpItemKindModule = { fg = C.base, bg = C.blue },
    --     CmpItemKindConstant = { fg = C.base, bg = C.peach },
    --     CmpItemKindField = { fg = C.base, bg = C.green },
    --     CmpItemKindProperty = { fg = C.base, bg = C.green },
    --     CmpItemKindEnum = { fg = C.base, bg = C.green },
    --     CmpItemKindUnit = { fg = C.base, bg = C.green },
    --     CmpItemKindClass = { fg = C.base, bg = C.yellow },
    --     CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
    --     CmpItemKindFile = { fg = C.base, bg = C.blue },
    --     CmpItemKindInterface = { fg = C.base, bg = C.yellow },
    --     CmpItemKindColor = { fg = C.base, bg = C.red },
    --     CmpItemKindReference = { fg = C.base, bg = C.red },
    --     CmpItemKindEnumMember = { fg = C.base, bg = C.red },
    --     CmpItemKindStruct = { fg = C.base, bg = C.blue },
    --     CmpItemKindValue = { fg = C.base, bg = C.peach },
    --     CmpItemKindEvent = { fg = C.base, bg = C.blue },
    --     CmpItemKindOperator = { fg = C.base, bg = C.blue },
    --     CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
    --     CmpItemKindCopilot = { fg = C.base, bg = C.teal },
    --   }
    -- end,
  },
}
