return {
  'saghen/blink.pairs',
  version = '*', -- (recommended) only required with prebuilt binaries

  -- download prebuilt binaries from github releases
  dependencies = 'saghen/blink.download',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  opts = function()
    vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { default = true, fg = '#cc241d', ctermfg = 'Red' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { default = true, fg = '#d65d0e', ctermfg = 'White' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { default = true, fg = '#d79921', ctermfg = 'Yellow' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { default = true, fg = '#689d6a', ctermfg = 'Green' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { default = true, fg = '#a89984', ctermfg = 'Cyan' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { default = true, fg = '#458588', ctermfg = 'Blue' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { default = true, fg = '#b16286', ctermfg = 'Magenta' })
    return {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
        enabled = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {},
        -- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L12
        pairs = {},
      },
      highlights = {
        enabled = true,
        groups = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
        -- FIX:
        -- unmatched_group = 'BlinkPairsUnmatched',
        matchparen = {
          enabled = true,
          group = 'MatchParen',
        },
      },
      debug = false,
    }
  end

}
