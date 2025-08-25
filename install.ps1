# Absolute path to the script directory
$DOTFILES_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Ensure autoload path exists
$autoload = "$env:USERPROFILE\vimfiles\autoload"
New-Item -ItemType Directory -Force -Path $autoload

# Copy vendored plug.vim
Copy-Item "$DOTFILES_DIR\vim\autoload\plug.vim" "$autoload\plug.vim" -Force

# Copy .vimrc
Copy-Item "$DOTFILES_DIR\.vimrc" "$env:USERPROFILE\_vimrc" -Force

Write-Host "Vim setup complete. Plugins are already included in the repo."

