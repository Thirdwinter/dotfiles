--INFO: set lazyrepo and local path
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://gIthub.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require 'config.options' --INFO: Options must be loaded before plugins
require 'lazy_setup' --INFO: loadind lazy plugins
require 'config.autocmd'
-- require 'config.highlights' --INFO: colorscheme setting in 'config.highlights'
require 'config.keymaps'

vim.cmd.colorscheme 'rose-pine-moon' ---@type 'tokyonight'|'catppuccin'|'rose-pine-moon'
