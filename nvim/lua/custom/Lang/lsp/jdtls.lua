local lombok_jar = '/usr/share/java/lombok/lombok.jar'
local jdtls_cmd = {
  'jdtls',
  '-configuration',
  os.getenv 'HOME' .. '/.cache/jdtls/config',
  '-data',
  os.getenv 'HOME' .. '/.cache/jdtls/workspace',
  '-javaagent:' .. lombok_jar, -- 添加 Lombok agent
}
return {
  cmd = jdtls_cmd,
}
