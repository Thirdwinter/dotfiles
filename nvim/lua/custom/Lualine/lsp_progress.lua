-- NOTE:
-- unused
local spinner_char = require('custom.Lualine.chars').spinner_char
return {
  --     local lsp_clients = vim.lsp.get_clients()

  spinner = spinner_char,
  client_format = function(_, spinner, series_messages)
    return #series_messages > 0 and (spinner .. 'LSP') or '󰅡 Lsp'
  end,
  format = function(client_messages)
    -- local lsp_clients = vim.lsp.get_clients()
    -- local sign = 'LSP'
    if #client_messages > 0 then
      return table.concat(client_messages)
    end
    if #vim.lsp.get_clients() > 0 then
      -- local first_client_name = lsp_clients[1].name
      return string.format('󰅡 %s', 'Lsp')

      -- return sign
    end
    return '󱏎 Lsp'
  end,
}

-- return {
--   spinner = spinner_char,
--   client_format = function(_, spinner, series_messages)
--     return #series_messages > 0 and (spinner .. 'LSP') or 'LSP'
--   end,
--   format = function(client_messages)
-- local sign = 'LSP'

--     local lsp_clients = vim.lsp.get_clients()
--     if #lsp_clients > 0 then
--       -- 只获取第一个 LSP 的名称
--       local first_client_name = lsp_clients[1].name
--       return first_client_name
--     end
--     return '󱏎LSP'
--   end,
-- }
