# C:\Users\Omer\ws\src\dotfiles\profile.ps1
# Source of truth for the PowerShell profile. The real $PROFILE files just
# dot-source this one so everything lives in the dotfiles repo.

$scoopShims = 'D:\Scoop\shims'
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

# Tab cycles through path/argument completions (git branches, files, etc. -
# posh-git registers the git-aware completions above; this is what triggers
# them from the keyboard).
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-Alias -Name which -Value Get-Command
Set-Alias -Name vim -Value nvim

# Land in the workspace root on every new shell.
Set-Location 'C:\Users\Omer\ws'

# Quick-jump directory shortcuts
function ws { Set-Location 'C:\Users\Omer\ws' }
function core { Set-Location 'C:\Users\Omer\ws\src\core' }
function common { Set-Location 'C:\Users\Omer\ws\src\core\tools\common' }
function tools { Set-Location 'C:\Users\Omer\ws\src\core\tools' }
function dotfiles { Set-Location 'C:\Users\Omer\ws\src\dotfiles' }
function desktop { Set-Location (Join-Path $HOME 'Desktop') }
function downloads { Set-Location (Join-Path $HOME 'Downloads') }
function documents { Set-Location (Join-Path $HOME 'Documents') }
function nvimconfig { Set-Location 'C:\Users\Omer\ws\src\dotfiles\nvim' }
function nvimdata { Set-Location (Join-Path $env:LOCALAPPDATA 'nvim-data') }

function lcore { Start-Process "https://gitlab.invisibleshare.com/seclous/core-2.0/core" }
function lgit { Start-Process "https://gitlab.invisibleshare.com/seclous/" }
function lpers { Start-Process "https://seclous.app.personio.com/" }
function lharb { Start-Process "https://registry.invisibleshare.com/harbor/projects" }
function larti { Start-Process "https://artifactory.invisibleshare.com/ui/packages" }
function lport { Start-Process "https://portal.nvd/" }

function conan_connect {
    if (-not $env:CONAN_TOKEN) {
        Write-Error "CONAN_TOKEN is not set."
        return
    }
    conan remote login -p $env:CONAN_TOKEN conan oemer
}

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
    & 'C:\Users\Omer\ws\src\karumono\tools\cbuild.bat' @args
}
