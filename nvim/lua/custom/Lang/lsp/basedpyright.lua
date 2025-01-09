return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  root_dir = function(fname)
    local util = require 'lspconfig.util'
    local dir_name = util.root_pattern(unpack {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      'pyrightconfig.json',
      '.git',
    })(fname)
    if dir_name == nil then
      return vim.fs.dirname(fname)
    else
      return dir_name
    end
  end,
}
