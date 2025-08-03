--INFO: enabled formaters
local formaters = {
  lua = { 'stylua' },
  yaml = { 'yamlfmt' },
  go = { 'goimports' },
  xml = { 'xmlformatter' },
  c = { 'clang-format' },
  cpp = { 'clang-format' },
  json = { 'fixjson' },
  jsonc = { 'fixjson' },
  zsh = { 'beautysh' },
  sh = { 'beautysh' },
  rust = { 'rustfmt' },
  typescript = { 'ts-standard' },
  typescriptreact = { 'prettier' },
  typst = { 'typstfmt' },
  css = { 'prettier' },
  scss = { 'prettier' },
  html = { ' htmlbeautifier' },
  xhtml = { ' htmlbeautifier' },

  -- Conform can also run multiple formatters sequentially
  -- python = { "isort", "black" },
  -- You can use 'stop_after_first' to run the first available formatter from the list
  -- javascript = { "prettierd", "prettier", stop_after_first = true },
}
return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>lf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = 'fallback',
      timeout_ms = 500,
    },
    formatters_by_ft = formaters,
  },
}
