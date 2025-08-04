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
  html = {
    filetypes = { 'html', 'xhtml', 'ncx' },
  },
  bashls = {
    filetypes = { 'sh', 'zsh' },
  },
  qmlls = {
    cmd = { 'qmlls', '-E' },
  },
  intelephense = {
    settings = {
      intelephense = {
        -- possible values: stubs.txt
        stubs = {
          'Core',
          'Reflection',
          'SPL',
          'SimpleXML',
          'ctype',
          'date',
          'exif',
          'filter',
          'hash',
          'imagick',
          'json',
          'pcre',
          'random',
          'standard',
          "dom",
        }
      }
    }
  },
  -- glsl_analyzer = {},

  --INFO: local lsp servers
  gopls = require 'custom.Lang.lsp.gopls',
  rust_analyzer = require 'custom.Lang.lsp.rust_analyzer',
}
local hover_ns = vim.api.nvim_create_namespace 'hover'
local lsp = vim.lsp
local api = vim.api
local util = lsp.util
local ms = vim.lsp.protocol.Methods
local function make_position_params()
  if vim.fn.has 'nvim-0.11' == 1 then
    return function(client)
      return vim.lsp.util.make_position_params(nil, client.offset_encoding)
    end
  else
    ---@diagnostic disable-next-line: missing-parameter
    return vim.lsp.util.make_position_params()
  end
end

local hover = function(config)
  config = config or {}
  config.border = config.border or vim.g.borderStyle or 'single'
  config.focus_id = ms.textDocument_hover
  require("config.hl_patch").set_hl({ NormalFloat = "Normal" }, { clear = true })

  local params = make_position_params()
  lsp.buf_request_all(0, ms.textDocument_hover, params, function(results, ctx)
    local bufnr = assert(ctx.bufnr)
    if api.nvim_get_current_buf() ~= bufnr then
      return
    end

    local results1 = {}
    for client_id, resp in pairs(results) do
      local err, result = resp.err, resp.result
      if err then
        lsp.log.error(err.code, err.message)
      elseif result then
        results1[client_id] = result
      end
    end

    if vim.tbl_isempty(results1) then
      if config.silent ~= true then
        vim.notify 'No information available'
      end
      return
    end

    local contents = {}
    local nresults = #vim.tbl_keys(results1)
    local format = 'markdown'

    for client_id, result in pairs(results1) do
      local client = assert(lsp.get_client_by_id(client_id))
      if nresults > 1 then
        contents[#contents + 1] = string.format('# %s', client.name)
      end

      if type(result.contents) == 'table' and result.contents.kind == 'plaintext' then
        if #results1 == 1 then
          format = 'plaintext'
          contents = vim.split(result.contents.value or '', '\n', { trimempty = true })
        else
          contents[#contents + 1] = '```'
          vim.list_extend(contents, vim.split(result.contents.value or '', '\n', { trimempty = true }))
          contents[#contents + 1] = '```'
        end
      else
        vim.list_extend(contents, util.convert_input_to_markdown_lines(result.contents))
      end

      if result.range then
        local start = result.range.start
        local end_ = result.range['end']
        local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
        local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)
        vim.hl.range(bufnr, hover_ns, 'LspReferenceTarget', { start.line, start_idx }, { end_.line, end_idx }, {
          priority = vim.hl.priorities.user,
        })
      end

      contents[#contents + 1] = '---'
    end
    contents[#contents] = nil

    if vim.tbl_isempty(contents) then
      if config.silent ~= true then
        vim.notify 'No information available'
      end
      return
    end

    local _, winid = util.open_floating_preview(contents, format, config)

    api.nvim_create_autocmd('WinClosed', {
      pattern = tostring(winid),
      once = true,
      callback = function()
        api.nvim_buf_clear_namespace(bufnr, hover_ns, 0, -1)
      end,
    })
  end)
end
-- vim.lsp.buf.hover = hover
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
    -- { 'saghen/blink.cmp' },
    -- { 'folke/snacks.nvim' },
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
      vim.lsp.config(server_name, server_opts)
      -- require('lspconfig')[server_name].setup(server_opts)
      vim.lsp.enable(server_name)
    end

    vim.cmd 'LspStart'
  end,
}
