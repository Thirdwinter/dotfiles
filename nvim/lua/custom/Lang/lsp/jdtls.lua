local lombok_jar = '/usr/share/java/lombok/lombok.jar'
local jdtls_cmd = {
  'jdtls',
  '-javaagent:' .. lombok_jar, -- 添加 Lombok agent
  '-configuration',
  os.getenv 'HOME' .. '/.cache/jdtls/config',
  '-data',
  os.getenv 'HOME' .. '/.cache/jdtls/workspace',
}
return {
  cmd = jdtls_cmd,
  settings = {
    java = {},
  },
  init_options = {
    bundles = {},
  },
}
