local lsp_servers = {
  --INFO: install by mason
  clangd = require 'custom.Lang.lsp.clangd',
  lua_ls = require 'custom.Lang.lsp.lua_ls',
  basedpyright = require 'custom.Lang.lsp.basedpyright',
  jdtls = require 'custom.Lang.lsp.jdtls',
  jsonls = require 'custom.Lang.lsp.jsonls',
  tinymist = {},
  systemd_ls = {},
  cssls = {},
  vtsls = {},
  sqlls = {},
  bashls = {
    filetypes = { 'sh', 'zsh' },
  },
  qmlls = {
    cmd = { 'qmlls', '-E' },
  },

  --INFO: local lsp servers
  gopls = require 'custom.Lang.lsp.gopls',
  rust_analyzer = require 'custom.Lang.lsp.rust_analyzer',
}

--INFO: mason_ensure_installed
---@diagnostic disable-next-line: unused-local
local mason_ensure_installed = {
  'stylua',
  'lua-language-server',
}
return {
  'neovim/nvim-lspconfig',
  -- event = 'VimEnter',
  -- event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    -- 自动将 LSP 和相关工具安装到 Neovim 的 stdpath
    { 'williamboman/mason.nvim',          opts = { ui = { border = vim.g.borderStyle, backdrop = 100 } } }, -- 注意：必须在依赖之前加载
    { 'williamboman/mason-lspconfig.nvim' },
    -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'saghen/blink.cmp' },
    { 'folke/snacks.nvim' },
  },
  config = function()
    --INFO: disable diagnostic using tiny-inline-diagnostic
    require 'custom.Lang.diagnostic'
    --INFO: lsp 相关的自动命令和键位映射
    require 'custom.Lang.lspAttach'

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    capabilities = vim.tbl_deep_extend(
      'force',
      capabilities,
      require('blink.cmp').get_lsp_capabilities {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
              resolveSupport = {
                properties = {
                  'documentation',
                  'detail',
                  'additionalTextEdits',
                  'deprecated',
                  'insertText',
                },
              },
            },
          },
        },
      }
    )

    -- require('mason').setup()

    -- require('mason-tool-installer').setup { ensure_installed = mason_ensure_installed }
    -- local custom_handlers = {
    --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single', style = 'list' }),
    --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    -- }

    for server_name, server_opts in pairs(lsp_servers) do
      server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
      -- server_opts.handlers = vim.tbl_deep_extend('force', {}, custom_handlers, server_opts.handlers or {})
      -- vim.lsp.config(server_name, server_opts)
      require('lspconfig')[server_name].setup(server_opts)
      -- vim.lsp.enable(server_name)
    end

    vim.cmd 'LspStart'
  end,
}
