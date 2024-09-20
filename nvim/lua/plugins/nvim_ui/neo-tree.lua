-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- if true then
--   return {}
-- end
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  cmd = 'Neotree',
  config = function()
    require 'custom.neotree'
    -- local keymaps_module = require 'configs.neotree.keymaps'
    -- keymaps_module.setup_keymaps()
  end,
  -- keys = require 'configs.neotree.keymaps',
  -- keys = {
  --   {
  --     '<leader>o',
  --     function()
  --       if vim.bo.filetype == 'neo-tree' then
  --         vim.cmd.wincmd 'p'
  --       else
  --         vim.cmd 'Neotree focus'
  --       end
  --     end,
  --     { desc = 'Toggle Explorer Focus', noremap = true, silent = true },
  --   },
  -- },
  --   local function toggle_explorer_focus()
  --   if vim.bo.filetype == 'neo-tree' then
  --     vim.cmd.wincmd 'p'
  --   else
  --     vim.cmd.Neotree 'focus'
  --   end
  -- end
  -- --INFO: 一个keymap 用于切换neotree的聚焦
  -- vim.keymap.set('n', '<leader>o', function()
  --   if vim.bo.filetype == 'neo-tree' then
  --     vim.cmd.wincmd 'p'
  --   else
  --     vim.cmd.Neotree 'focus'
  --   end
  -- end, { desc = 'Toggle Explorer Focus', noremap = true, silent = true }),
}
