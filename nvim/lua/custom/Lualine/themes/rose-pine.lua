local p = {
  _nc = "#16141f",
  base = "#191724",
  surface = "#1f1d2e",
  overlay = "#26233a",
  muted = "#6e6a86",
  subtle = "#908caa",
  text = "#e0def4",
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ebbcba",
  pine = "#31748f",
  foam = "#9ccfd8",
  iris = "#c4a7e7",
  leaf = "#95b1ac",
  highlight_low = "#21202e",
  highlight_med = "#403d52",
  highlight_high = "#524f67",
  none = "NONE",
}

-- local config = require("rose-pine.config")
local bg_base = p.surface
-- if config.options.styles.transparency then
bg_base = "NONE"
-- end

return {
  normal = {
    a = { bg = p.rose, fg = p.base, gui = "bold" },
    b = { bg = p.overlay, fg = p.rose },
    c = { bg = bg_base, fg = p.text },
  },
  -- terminal = {
  --   a = { bg = p.rose, fg = p.base, gui = "bold" },
  --   b = { bg = p.overlay, fg = p.rose },
  --   c = { bg = bg_base, fg = p.text },
  -- },
  insert = {
    a = { bg = p.foam, fg = p.base, gui = "bold" },
    b = { bg = p.overlay, fg = p.foam },
    c = { bg = bg_base, fg = p.text },
  },
  visual = {
    a = { bg = p.iris, fg = p.base, gui = "bold" },
    b = { bg = p.overlay, fg = p.iris },
    c = { bg = bg_base, fg = p.text },
  },
  replace = {
    a = { bg = p.pine, fg = p.base, gui = "bold" },
    b = { bg = p.overlay, fg = p.pine },
    c = { bg = bg_base, fg = p.text },
  },
  command = {
    a = { bg = p.love, fg = p.base, gui = "bold" },
    b = { bg = p.overlay, fg = p.love },
    c = { bg = bg_base, fg = p.text },
  },
  inactive = {
    a = { bg = bg_base, fg = p.muted, gui = "bold" },
    b = { bg = bg_base, fg = p.muted },
    c = { bg = bg_base, fg = p.muted },
  },
}
