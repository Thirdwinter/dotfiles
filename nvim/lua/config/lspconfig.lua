vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { '.git' },
})
vim.lsp.config('rust-analyzer', {
  filetypes = { 'rust' },
})
