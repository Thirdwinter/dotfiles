return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { '.git', 'composer.json' },
  settings = {
    intelephense = {
      -- possible values: stubs.txt
      stubs = {
        'Core',
        'Reflection',
        'SPL',
        'SimpleXML',
        'ctype',
        'date',
        'exif',
        'filter',
        'hash',
        'imagick',
        'json',
        'pcre',
        'random',
        'standard',
        "dom",
      }
    }
  }
}
