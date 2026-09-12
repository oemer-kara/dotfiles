# C:\ws\src\dotfiles\profile.ps1
# Source of truth for the PowerShell profile. The real $PROFILE files just
# dot-source this one so everything lives in the dotfiles repo.

$scoopShims = 'C:\ws\scoop\shims'
if (($env:Path -split ';') -notcontains $scoopShims) {
    $env:Path = "$scoopShims;$env:Path"
}

if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Cursor

Set-Alias -Name which -Value Get-Command
Set-Alias -Name vim -Value nvim

# Quick-jump directory shortcuts (mirrors the WezTerm Leader quick-jump keys)
function ws { Set-Location 'C:\ws' }
function tools { Set-Location 'C:\ws\tools' }
function desktop { Set-Location (Join-Path $HOME 'Desktop') }
function downloads { Set-Location (Join-Path $HOME 'Downloads') }
function documents { Set-Location (Join-Path $HOME 'Documents') }
function nvimconfig { Set-Location 'C:\ws\src\dotfiles\nvim' }
function nvimdata { Set-Location (Join-Path $env:LOCALAPPDATA 'nvim-data') }
function km { Set-Location 'C:\ws\src\karumono' }

# Runs a .bat/.cmd script in a child cmd.exe and imports any environment
# variables it sets into the current PowerShell session. Needed for scripts
# like vcvarsall.bat, whose env changes otherwise die with the child process.
function Invoke-CmdScript {
    param(
        [Parameter(Mandatory)][string]$Path,
        [string[]]$ScriptArgs = @()
    )

    $tempFile = [System.IO.Path]::GetTempFileName()
    try {
        $argString = ($ScriptArgs | ForEach-Object { if ($_ -match '\s') { '"' + $_ + '"' } else { $_ } }) -join ' '
        cmd.exe /c "call `"$Path`" $argString && set > `"$tempFile`""

        Get-Content $tempFile | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') {
                Set-Item -Path "Env:$($Matches[1])" -Value $Matches[2]
            }
        }
    } finally {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}

# karumono's tools\vcvarsall.bat hardcodes a VS "Community" path that doesn't
# match this machine's BuildTools install, so resolve VS via vswhere instead
# of relying on that script.
function vcvarsall {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsInstallPath = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if (-not $vsInstallPath) {
        Write-Error 'vcvarsall: no Visual Studio install with the VC tools found via vswhere.'
        return
    }
    Invoke-CmdScript -Path (Join-Path $vsInstallPath 'VC\Auxiliary\Build\vcvarsall.bat') -ScriptArgs @('x64')
}

# Lets `cbuild` be typed without the .bat extension; makes sure the MSVC
# toolchain (cl/nmake) is on PATH first since cbuild.py shells out to nmake.
function cbuild {
    if (-not $env:VCToolsInstallDir) {
        vcvarsall
    }
    & 'C:\ws\src\karumono\tools\cbuild.bat' @args
}
