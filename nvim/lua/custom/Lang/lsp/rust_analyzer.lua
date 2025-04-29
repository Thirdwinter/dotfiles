return {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
      imports = {
        granularity = {
          group = 'module',
        },
        prefix = 'self',
      },
      inlayHints = {
        bindingModeHints = {
          enable = true,
        },
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
}
