-- if true then
--   return {}
-- end
vim.api.nvim_set_hl(0, 'CustomFoldText', {
  bg = '#f9e2b0', -- 圆弧/文字颜色
  fg = '#1e1e2e', -- 椭圆形整体背景
  bold = true,
})
vim.api.nvim_set_hl(0, 'CustomFold', {
  fg = '#f9e2b0', -- 圆弧/文字颜色
})

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d lines'):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, { chunkText, chunk[2] }) -- Use the original highlight group
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end

  table.insert(newVirtText, { ' ', nil })
  table.insert(newVirtText, { '◖', 'CustomFold' })
  table.insert(newVirtText, { suffix, 'CustomFoldText' })
  table.insert(newVirtText, { '◗', 'CustomFold' })
  return newVirtText
end
return {
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = { { 'kevinhwang91/promise-async', lazy = true } },
  opts = {
    fold_virt_text_handler = handler,

    preview = {
      mappings = {
        scrollB = '<C-B>',
        scrollF = '<C-F>',
        scrollU = '<C-U>',
        scrollD = '<C-D>',
      },
    },
    provider_selector = function(_, filetype, buftype)
      local function handleFallbackException(bufnr, err, providerName)
        if type(err) == 'string' and err:match 'UfoFallbackException' then
          return require('ufo').getFolds(bufnr, providerName)
        else
          return require('promise').reject(err)
        end
      end

      return (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
          or function(bufnr)
            return require('ufo')
                .getFolds(bufnr, 'lsp')
                :catch(function(err)
                  return handleFallbackException(bufnr, err, 'treesitter')
                end)
                :catch(function(err)
                  return handleFallbackException(bufnr, err, 'indent')
                end)
          end
    end,
  },
}
