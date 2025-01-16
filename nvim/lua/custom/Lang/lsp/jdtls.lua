-- local lombok_jar = '/usr/share/java/lombok/lombok.jar'
-- local jdtls_cmd = {
--   'jdtls',
--   '-javaagent:' .. lombok_jar, -- 添加 Lombok agent
--   '-configuration',
--   os.getenv 'HOME' .. '/.cache/jdtls/config',
--   '-data',
--   os.getenv 'HOME' .. '/.cache/jdtls/workspace',
-- }
vim.fn.setenv('JDTLS_JVM_ARGS', '-javaagent:/usr/share/java/lombok/lombok.jar')
-- local lsp_ext = require 'lsp-ext'
-- local function on_init(client, _)
--   lsp_ext.setup(client)
-- end
return {
  -- settings = {
  --   java = {
  --     eclipse = {
  --       downloadSources = true,
  --     },
  --     configuration = {
  --       updateBuildConfiguration = 'interactive',
  --     },
  --     maven = {
  --       downloadSources = true,
  --     },
  --     implementationsCodeLens = {
  --       enabled = true,
  --     },
  --     referencesCodeLens = {
  --       enabled = true,
  --     },
  --     references = {
  --       includeDecompiledSources = true,
  --     },
  --     format = {
  --       enabled = true,
  --     },
  --   },
  --   signatureHelp = { enabled = true },
  --   completion = {
  --     favoriteStaticMembers = {
  --       'org.hamcrest.MatcherAssert.assertThat',
  --       'org.hamcrest.Matchers.*',
  --       'org.hamcrest.CoreMatchers.*',
  --       'org.junit.jupiter.api.Assertions.*',
  --       'java.util.Objects.requireNonNull',
  --       'java.util.Objects.requireNonNullElse',
  --       'org.mockito.Mockito.*',
  --     },
  --   },
  --   contentProvider = { preferred = 'fernflower' },
  -- },
  -- vim.fn.setenv('JDTLS_JVM_ARGS', '-javaagent:/usr/share/java/lombok/lombok.jar'),
  -- cmd = jdtls_cmd,
  -- settings = {
  --   java = {},
  -- },
  init_options = {
    -- bundles = {
    extendedClientCapabilities = {
      classFileContentsSupport = true,
    },
    -- },
  },
  -- capabilities = {
  --   classFileContentsSupport = true,
  -- },
}
