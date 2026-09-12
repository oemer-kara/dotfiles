# C:\ws\src\dotfiles\profile.ps1
# Source of truth for the PowerShell profile. The real $PROFILE files just
# dot-source this one so everything lives in the dotfiles repo.

$scoopShims = 'C:\ws\scoop\shims'
if (($env:Path -split ';') -notcontains $scoopShims) {
    $env:Path = "$scoopShims;$env:Path"
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

Set-Alias -Name which -Value Get-Command
Set-Alias -Name vim -Value nvim
