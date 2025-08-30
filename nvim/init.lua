-- INFO: set lazyrepo and local path
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require 'config.options' -- INFO: Options must be loaded before plugins
require 'lazy_setup'     -- INFO: loadind lazy plugins
require 'config.autocmd' -- INFO: user auto command
require 'config.keymaps' -- INFO: base keymaps
require 'custom'         -- INFO: some plugin config and custom patch

vim.cmd.colorscheme 'catppuccin' ---@type 'tokyonight'|'catppuccin'
-- vim.cmd "filetype detect"
