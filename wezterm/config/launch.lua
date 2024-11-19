local platform = require('utils.platform')()

local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   options.default_prog = { 'D:\\Scoop\\apps\\nu\\current\\nu.exe' }
   options.launch_menu = {
      {
         label = 'Nushell',
         args = { 'D:\\Scoop\\apps\\nu\\current\\nu.exe' },
      },
      {
         label = 'Zsh',
         args = {
            'D:\\Scoop\\apps\\msys2\\current\\msys2_shell.cmd',
            '-defterm',
            '-no-start',
            '-use-full-path',
            '-here',
            '-ucrt64',
         },
      },
      { label = 'PowerShell', args = { 'powershell' } },
      {
         label = 'Bash',
         args = { 'D:\\Git\\bin\\bash.exe' },
      },
      { label = 'Cmd', args = { 'cmd' } },
      { label = 'pwsh', args = { 'pwsh' } },
      -- { lebel = 'Arch', args = { 'C:\\WINDOWS\\system32\\wsl.exe -d Arch' }, cwd = '/root' },
   }
elseif platform.is_mac then
   options.default_prog = { '/opt/homebrew/bin/fish', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { '/opt/homebrew/bin/fish', '-l' } },
      { label = 'Nushell', args = { '/opt/homebrew/bin/nu', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'fish', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { 'fish', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
end

return options
