# Absolute path to the script directory
$DOTFILES_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Path to the repo's .vimrc
$vimrcPath = Join-Path $DOTFILES_DIR ".vimrc"

if (-not (Test-Path $vimrcPath)) {
  Write-Error "Error: .vimrc not found at $vimrcPath"
  exit 1
}

# Set VIMINIT environment variable for current user
$viminit = "source $vimrcPath"
[Environment]::SetEnvironmentVariable("VIMINIT", $viminit, "User")

# Set for current session
$env:VIMINIT = $viminit

# Setup Neovim to use the same configuration
$nvimConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
New-Item -ItemType Directory -Force -Path $nvimConfigDir | Out-Null
$initVimPath = Join-Path $nvimConfigDir "init.vim"
"source $vimrcPath" | Set-Content -Encoding UTF8 -Path $initVimPath

Write-Host "Vim setup complete. VIMINIT points to repo's .vimrc at: $vimrcPath"
Write-Host "Neovim configured to use the same .vimrc"
Write-Host "Please restart your shell/PowerShell for environment variable to take effect"

