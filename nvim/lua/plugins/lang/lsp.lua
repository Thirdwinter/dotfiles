return {
  {
    -- `lazydev` 配置你的 Neovim 配置、运行时和插件的 Lua LSP
    -- 用于 Neovim API 的补全、注释和签名
    'folke/lazydev.nvim',
    evnet = 'VimEnter',
    ft = 'lua',
    opts = {
      library = {
        -- 当发现 `vim.uv` 单词时，加载 luvit 类型
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
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

      -- 导入必要的模块
      local vim_diagnostic = vim.diagnostic

      -- 定义诊断图标
      local signs = {
        { name = 'DiagnosticSignError', text = '', color = 'DiagnosticError' },
        { name = 'DiagnosticSignWarn', text = '', color = 'DiagnosticWarn' },
        { name = 'DiagnosticSignHint', text = '', color = 'DiagnosticHint' },
        { name = 'DiagnosticSignInfo', text = '', color = 'DiagnosticInfo' },
      }

      -- 注册诊断图标
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.color, numhl = '' })
      end

      -- 配置诊断显示
      vim_diagnostic.config {
        -- underline = true,
        -- update_in_insert = false,
        -- virtual_text = {
        --   spacing = 4,
        --   perfix = '●',
        -- },
        signs = { active = signs }, -- 是否在边缘显示诊断图标
        underline = true, -- 是否给诊断信息下的文本加下划线
        severity_sort = true, -- 是否根据严重性级别排序
        update_in_insert = true, -- 在插入模式下是否更新诊断信息
        float = { -- 浮动窗口的配置
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          -- source = 'always',
          header = '',
          prefix = '',
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- 注意：记住 Lua 是一种真正的编程语言，因此你可以定义小型帮助和实用函数，以免重复自己。
          --
          -- 在这种情况下，我们创建一个函数，让我们更容易地定义特定于 LSP 项目的映射。它为我们每次设置模式、缓冲区和描述。
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- 跳转到光标下的单词的定义。
          -- 这是变量首次声明的地方，或者函数定义的地方等。
          -- 要跳回来，按 <C-t>。
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- 查找光标下单词的引用。
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- 跳转到光标下的单词的实现。
          -- 当你的语言有声明类型但没有实际实现的方式时，这很有用。
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- 跳转到光标下的单词的类型。
          -- 当你不确定一个变量的类型并且你想要看到它的 *类型* 的定义时，这很有用，而不是它被 *定义* 的地方。
          map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- 在当前文档中模糊查找所有符号。
          -- 符号是变量、函数、类型等。
          map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- 在当前工作区中模糊查找所有符号。
          -- 类似于文档符号，只是搜索整个项目。
          map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- 重命名光标下的变量。
          -- 大多数语言服务器支持跨文件重命名等。
          map('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')

          -- lsp info
          map('<leader>li', '<CMD>LspInfo<CR>', '[L]sp [I]nfo')

          -- map('<leader>l', '', '[L]sp')
          -- 执行代码操作，通常你的光标需要在错误上
          -- 或者 LSP 的建议上，这才会激活。
          map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- 警告：这不是 Goto Definition，这是 Goto Declaration。
          -- 例如，在 C 中，这会带你去头文件。
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- 以下两个自动命令用于在光标停留在光标下的
          -- 单词上一小段时间后高亮显示引用。
          --   参见 `:help CursorHold` 了解何时执行
          --
          -- 当你移动光标时，高亮显示将被清除（第二个自动命令）。
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- 下面的代码创建了一个键位映射，用于在代码中切换内联提示，
          -- 如果你使用的语言服务器支持它们
          --
          -- 这可能是不需要的，因为它们会替换你的一些代码
          vim.lsp.inlay_hint.enable(false)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP 服务器和客户端能够相互通信他们支持的功能。
      --  默认情况下，Neovim 不支持 LSP 规范中的所有内容。
      --  当你添加 nvim-cmp，luasnip 等，Neovim 现在有 *更多* 的功能。
      --  因此，我们使用 nvim cmp 创建新的功能，然后将其广播到服务器。
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      local mason_servers = {
        clangd = { capabilities = { offsetEncoding = 'utf-8' }, cmd = { 'clangd' } },
        pylsp = {
          pyflake = { enabled = false },
          pylint = { enabled = false },
        },
        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = { 'stylua', 'lua-language-server' }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Define custom handlers for hover and signature help
      local lspconfig = require 'lspconfig'
      -- local custom_handlers = {
      --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
      --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' }),
      -- }
      local function setup_server_mason(server_name, config)
        -- Extend capabilities with defaults and server-specific capabilities
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        -- config.handlers = vim.tbl_deep_extend('force', {}, custom_handlers, config.handlers or {})
        lspconfig[server_name].setup(config)
      end
      for server_name, config in pairs(mason_servers) do
        setup_server_mason(server_name, config)
      end

      local local_servers = {
        jdtls = {},
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            imports = {
              granularity = { group = 'module' },
              prefix = 'self',
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
          },
        },
        basedpyright = {
          cmd = { 'basedpyright-langserver', '--stdio' },
          root_dir = function(fname)
            local util = require 'lspconfig.util'
            local dir_name = util.root_pattern(unpack {
              'pyproject.toml',
              'setup.py',
              'setup.cfg',
              'requirements.txt',
              'Pipfile',
              'pyrightconfig.json',
              '.git',
            })(fname)
            if dir_name == nil then
              return vim.fs.dirname(fname)
            else
              return dir_name
            end
          end,
        },
      }

      for server_name, server_opts in pairs(local_servers) do
        require('lspconfig')[server_name].setup(server_opts)
      end

      vim.cmd 'LspStart'
    end,
  },
}
