-- 与插件关系密切的一些设置，可能会经常改动
-- local Neotree = require 'neo-tree'
--
local M = {}
M.transparent_background = function()
  if vim.g.neovide then
    return false
  else
    return true
  end
end
-- M.transparent_background = vim.g.neovide and false or true
return M
