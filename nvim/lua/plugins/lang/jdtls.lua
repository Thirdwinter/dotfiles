if true then
  return {}
end
return {
  'mfussenegger/nvim-jdtls',
  config = function()
    local jdtls_path = vim.fn.stdpath 'data' .. '/mason/package/jdtls'
    local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
    local lombok_jar = vim.fn.glob(jdtls_path .. '/lombok.jar')
    local jdtls = require 'jdtls'
    local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    local config = {
      cmd = {

        -- 💀
        'java', -- or '/path/to/java17_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:/usr/share/java/lombok/lombok.jar',
        -- 💀
        '-jar',
        '/home/thirdwinter/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
        -- launcher_jar,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version

        -- 💀
        '-configuration',
        '/home/thirdwinter/.local/share/nvim/mason/packages/jdtls/config_linux',
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.

        -- 💀
        -- See `data directory configuration` section in the README
        '-data',
        '/home/thirdwinter/.cache/jdtls/workspace',
      },
      -- settings = {
      -- ['java.format.settings.url'] = vim.fn.expand '~/formatter.xml',
      -- },
      root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
      init_options = {
        -- bundles = bundles;
        extendedClientCapabilities = extendedClientCapabilities,
      },
      on_attach = function(client, bufnr)
        -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
        local opts = { silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>lo', jdtls.organize_imports, { desc = 'Organize imports', buffer = bufnr })
        -- Should 'd' be reserved for debug?
        vim.keymap.set('n', '<leader>df', jdtls.test_class, opts)
        vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
        vim.keymap.set('n', '<leader>rv', jdtls.extract_variable_all, { desc = 'Extract variable', buffer = bufnr })
        vim.keymap.set('v', '<leader>rm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { desc = 'Extract method', buffer = bufnr })
        vim.keymap.set('n', '<leader>rc', jdtls.extract_constant, { desc = 'Extract constant', buffer = bufnr })
      end,
    }
    require('jdtls').start_or_attach(config)
  end,
}
