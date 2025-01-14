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

return {
  -- vim.fn.setenv('JDTLS_JVM_ARGS', '-javaagent:/usr/share/java/lombok/lombok.jar'),
  -- cmd = jdtls_cmd,
  -- settings = {
  --   java = {},
  -- },
  -- init_options = {
  --   jvm_args = {
  --     javaagent = '/usr/share/java/lombok/lombok.jar',
  --   },
  --   -- bundles = {},
  -- },
}
