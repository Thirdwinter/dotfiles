-- if true then
--   return {}
-- end
return {
  "VidocqH/lsp-lens.nvim",
  event = 'LspAttach',
  -- cond = function()
  --   local buf = vim.api.nvim_get_current_buf()
  --   local file = vim.api.nvim_buf_get_name(buf)
  --   if file ~= "" then
  --     local stat = vim.loop.fs_stat(file)
  --     return not (stat and stat.size > 150 * 1024)       -- 150KB
  --   end
  -- end,
  opts = {
    sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
      definition = true,
      references = true,
      implements = true,
      git_authors = false,
    },
  }
}
