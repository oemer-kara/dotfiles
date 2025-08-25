# Copy .vimrc
Copy-Item "$PSScriptRoot\.vimrc" "$env:USERPROFILE\_vimrc" -Force

# Ensure autoload path exists
$autoload = "$env:USERPROFILE\vimfiles\autoload"
New-Item -ItemType Directory -Force -Path $autoload

# Copy vendored plug.vim
Copy-Item "$PSScriptRoot\vim\autoload\plug.vim" "$autoload\plug.vim" -Force
