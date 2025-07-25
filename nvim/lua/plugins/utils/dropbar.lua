-- if true then
--   return {}
-- end
return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  config = function()
    local dropbar_api = require('dropbar.api')
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })

    local sources = require('dropbar.sources')
    local utils = require('dropbar.utils')

    local custom_path = {
      get_symbols = function(buff, win, cursor)
        -- 只保留文件名部分
        local symbols = sources.path.get_symbols(buff, win, cursor)
        -- 只保留最后一个（文件名）
        return { symbols[#symbols] }
      end,
    }


    require('dropbar').setup({
      bar = {
        enable = function(buf, win, _)
          if
              not vim.api.nvim_buf_is_valid(buf)
              or not vim.api.nvim_win_is_valid(win)
              or vim.fn.win_gettype(win) ~= ''
              or vim.wo[win].winbar ~= ''
              or vim.bo[buf].ft == 'help'
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 150 then
            return false
          end

          return vim.bo[buf].ft == 'markdown'
              or pcall(vim.treesitter.get_parser, buf)
              or not vim.tbl_isempty(vim.lsp.get_clients({
                bufnr = buf,
                method = 'textDocument/documentSymbol',
              }))
        end,
        sources = function(buf, _)
          if vim.bo[buf].ft == 'markdown' then
            return {
              custom_path,
              utils.source.fallback {
                sources.lsp,
                sources.treesitter,
              },
            }
          else
            return {
              custom_path,
              utils.source.fallback {
                sources.lsp,
                -- sources.treesitter,
              },
            }
          end
        end,
      }
    }
    )
  end
}
