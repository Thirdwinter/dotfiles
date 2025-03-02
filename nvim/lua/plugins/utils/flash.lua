return {
  'folke/flash.nvim',
  -- lazy = true,
  event = 'VeryLazy',
  opts = {
    modes = {
      search = {
        enabled = true,
        highlight = {
          backdrop = true,
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "m", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "M", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "<Leader>r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "<Leader>R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Serch" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
