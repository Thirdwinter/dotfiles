local lsp_servers = {
  --INFO: install by mason
  -- clangd = require 'custom.Lang.lsp.clangd',
  -- lua_ls = require 'custom.Lang.lsp.lua_ls',
  -- basedpyright = require 'custom.Lang.lsp.basedpyright',
  jsonls = require 'custom.Lang.lsp.jsonls',
  systemd_ls = {},
  cssls = {},
  nginx_language_server = {},
  html = {
    filetypes = { 'html', 'xhtml', 'ncx' },
  },
  bashls = {
    filetypes = { 'sh', 'zsh' },
  },
  --INFO: local lsp servers
  -- gopls = require 'custom.Lang.lsp.gopls',
  -- rust_analyzer = require 'custom.Lang.lsp.rust_analyzer',
}

--INFO: mason_ensure_installed
---@diagnostic disable-next-line: unused-local
local mason_ensure_installed = {
  'stylua',
  'lua-language-server',
}

return {
  {
    'neovim/nvim-lspconfig',
    -- event = 'VimEnter',
    -- event = 'UIEnter',
    enabled = false,
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      -- 自动将 LSP 和相关工具安装到 Neovim 的 stdpath
      { 'williamboman/mason.nvim' }, -- 注意：必须在依赖之前加载
      { 'williamboman/mason-lspconfig.nvim' },
      -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- { 'saghen/blink.cmp' },
      -- { 'folke/snacks.nvim' },
    },
    config = function()
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- capabilities = vim.tbl_deep_extend(
      --   'force',
      --   capabilities,
      --   require('blink.cmp').get_lsp_capabilities {
      --     textDocument = {
      --       completion = {
      --         completionItem = {
      --           snippetSupport = true,
      --           resolveSupport = {
      --             properties = {
      --               'documentation',
      --               'detail',
      --               'additionalTextEdits',
      --               'deprecated',
      --               'insertText',
      --             },
      --           },
      --         },
      --       },
      --     },
      --   }
      -- )

      -- require('mason').setup()

      -- require('mason-tool-installer').setup { ensure_installed = mason_ensure_installed }
      -- local custom_handlers = {
      --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single', style = 'list' }),
      --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
      -- }

      for server_name, server_opts in pairs(lsp_servers) do
        -- server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
        -- server_opts.handlers = vim.tbl_deep_extend('force', {}, custom_handlers, server_opts.handlers or {})
        vim.lsp.config(server_name, server_opts)
        -- require('lspconfig')[server_name].setup(server_opts)
        vim.lsp.enable(server_name)
      end

      vim.cmd 'LspStart'
    end,
  },
  {
    'williamboman/mason.nvim',
    -- event = { 'BufReadPost', 'BufNewFile' },
    opts = { ui = { border = vim.g.borderStyle, backdrop = 100 } }
  }, -- 注意：必须在依赖之前加载
  {
    'williamboman/mason-lspconfig.nvim',
    -- event = { 'BufReadPost', 'BufNewFile' }
  }
}
