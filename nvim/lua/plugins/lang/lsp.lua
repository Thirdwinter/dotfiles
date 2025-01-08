return {
  {
    -- 主 LSP 配置
    'neovim/nvim-lspconfig',
    -- event = 'VimEnter',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      -- 自动将 LSP 和相关工具安装到 Neovim 的 stdpath
      { 'williamboman/mason.nvim', config = true }, -- 注意：必须在依赖之前加载
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',

      -- LSP 的有用状态更新。
      -- 注意：`opts = {}` 与调用 `require('fidget').setup({})` 相同
      { 'j-hui/fidget.nvim', opts = {} },

      -- 允许由 nvim-cmp 提供的额外功能
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      --INFO: disable diagnostic using tiny-inline-diagnostic
      require 'plugins.lang.lsp_pack.diagnostic'
      --INFO: lsp 相关的自动命令和键位映射
      require 'plugins.lang.lsp_pack.lsp_cmd'

      local lspconfig = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      local lsp_servers = {
        --INFO: install by mason
        clangd = require 'plugins.lang.lsp_pack.clangd',
        lua_ls = require 'plugins.lang.lsp_pack.lua_ls',
        basedpyright = require 'plugins.lang.lsp_pack.basedpyright',
        jdtls = {},

        --INFO: local lsp servers
        gopls = require 'plugins.lang.lsp_pack.gopls',
        rust_analyzer = require 'plugins.lang.lsp_pack.rust_analyzer',
      }

      require('mason').setup()

      local ensure_installed = { 'stylua', 'lua-language-server' }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      -- local custom_handlers = {
      --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
      --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' }),
      -- -- }
      -- local function setup_server_mason(server_name, config)
      --   -- Extend capabilities with defaults and server-specific capabilities
      --   config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
      --   -- config.handlers = vim.tbl_deep_extend('force', {}, custom_handlers, config.handlers or {})
      --   lspconfig[server_name].setup(config)
      -- end

      for server_name, server_opts in pairs(lsp_servers) do
        lspconfig[server_name].setup(server_opts)
      end

      vim.cmd 'LspStart'
    end,
  },
}
