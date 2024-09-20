if vim.g.neovide then
  return {
    "binhtran432k/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- transparent = true,
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
        -- Background styles. Can be "dark", "transparent" or "normal"
        -- sidebars = "transparent", -- style for sidebars, see below
        -- floats = "transparent", -- style for floating windows
      },
    },
  }
end

return {
  "binhtran432k/dracula.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = true },
      variables = { italic = true },
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent", -- style for sidebars, see below
      floats = "transparent", -- style for floating windows
    },
  },
}
