return {
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client:supports_method 'textDocument/foldingRange' then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end,
  }),
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

      -- 跳转到光标下的单词的类型。
      -- 当你不确定一个变量的类型并且你想要看到它的 *类型* 的定义时，这很有用，而不是它被 *定义* 的地方。
      map('gd', function()
        Snacks.picker.lsp_definitions()
      end, '[G]oto [D]efinitions')

      -- 查找光标下单词的引用。
      map(
        'gr',
        -- '<cmd>Glance definitions<cr>',
        function()
          Snacks.picker.lsp_references()
        end,
        '[G]oto [R]eferences'
      )

      -- 跳转到光标下的单词的实现。
      -- 当你的语言有声明类型但没有实际实现的方式时，这很有用。
      map(
        'gI',
        -- '<CMD>Glance implementations<CR>',
        function()
          Snacks.picker.lsp_implementations()
        end,
        '[G]oto [I]mplementation'
      )


      -- 跳转到光标下的单词的定义。
      -- 这是变量首次声明的地方，或者函数定义的地方等。
      -- 要跳回来，按 <C-t>。
      map('<leader>lD', function()
        Snacks.picker.lsp_declarations()
      end, '[G]oto [D]eclarations')

      -- 在当前文档中模糊查找所有符号。
      -- 符号是变量、函数、类型等。
      -- map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

      -- 在当前工作区中模糊查找所有符号。
      -- 类似于文档符号，只是搜索整个项目。
      map('<leader>lws', function()
        Snacks.picker.lsp_workspace_symbols()
      end, '[W]orkspace [S]ymbols')

      -- 重命名光标下的变量。
      -- 大多数语言服务器支持跨文件重命名等。
      map('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')

      -- lsp info
      map('<leader>li', '<CMD>LspInfo<CR>', '[L]sp [I]nfo')

      -- map('<leader>l', '', '[L]sp')
      -- 执行代码操作，通常你的光标需要在错误上
      -- 或者 LSP 的建议上，这才会激活。
      map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

      -- map('<leader>la', '<cmd>Lspsaga code_action<CR>', '[A]ction', { 'n', 'x' })

      -- 警告：这不是 Goto Definition，这是 Goto Declaration。
      -- 例如，在 C 中，这会带你去头文件。
      -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('gD', function()
        Snacks.picker.lsp_type_definitions()
      end, '[G]oto [T]ype [D]efinition')

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
  }),
}
