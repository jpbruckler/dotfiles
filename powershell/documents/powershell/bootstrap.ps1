<#
.SYNOPSIS
    Bootstrap script for setting up a new machine with dotfiles from github.
.DESCRIPTION
    Sets up dotfiles, installs modules, installs core software and package managers.

    - Install-Module is aliased to Install-ModuleFast
    - Config alias is created
#>
param(
    [switch] $ChocoOnly,
    [switch] $SkipProfileUpdate
)
$env:WRITE_CONSOLE_INCLUDE_DATETIME = $false                                    # Set to $true to include datetime in console messages
$env:LOCAL_DOTFILE_PATH = Join-Path $HOME -ChildPath '.dotfiles'    # Set to the path where your dotfile bare repository should be created
$env:XDG_CONFIG_HOME = Join-Path $HOME -ChildPath '.config'      # This causes neovim to look for config in $HOME/.config
$INSTALL_CHOCO = $false
$INSTALL_SCOOP = $true
$chocoPackages = @()

$scoopBuckets = @(
    'extras',
    'nerd-fonts'
)

$scoopPackages = @(
    '7zip',
    'ripgrep',
    'infisical',
    'lua-for-windows',
    'lua-language-server',
    'luarocks',
    'fzf',
    'zig',
    'vcredist-aio',
    'JetBrainsMono-NF-Propo',
    'cmake',
    'make',
    'unzip',
    'mingw'
)

#region Helper functions
function Invoke-DotfileGit {
    git --git-dir "$env:LOCAL_DOTFILE_PATH" --work-tree="$HOME" $args
}

function Install-Scoop {
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression -ErrorAction Stop
    } 
    catch {
        throw "Unable to install 'scoop'. Error: $($_)"
    }
}

enum ConsoleStatus {
    Info
    Warn
    Error
    Verbose
    Debug
    Success
}

function Write-Console {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [string]$Message,

        [Parameter(Position = 2)]
        [ConsoleStatus]$Status = [ConsoleStatus]::Info,

        [switch]$StartTask,
        [switch]$EndTask,
        [switch]$ResetIndent,
        [switch]$SkipIndent,
        [switch]$NoNewline
    )

    begin {
        # Initialize continuation state if needed
        if (-not (Test-Path Variable:Script:ConsoleLastNoNewline)) {
            $Script:ConsoleLastNoNewline = $false
        }

        # Emoji mapping stays whimsical 🎪
        $statusCodes = @{
            [ConsoleStatus]::Info    = 'ℹ️'
            [ConsoleStatus]::Warn    = '⚠️'
            [ConsoleStatus]::Error   = '❌'
            [ConsoleStatus]::Verbose = '🔍'
            [ConsoleStatus]::Debug   = '🐞'
            [ConsoleStatus]::Success = '✅'
        }

        # Color mapping with success! 🌈
        $colorMapping = @{
            [ConsoleStatus]::Info    = [ConsoleColor]::DarkGray
            [ConsoleStatus]::Warn    = [ConsoleColor]::DarkYellow
            [ConsoleStatus]::Error   = [ConsoleColor]::DarkRed
            [ConsoleStatus]::Verbose = [ConsoleColor]::Yellow
            [ConsoleStatus]::Debug   = [ConsoleColor]::DarkCyan
            [ConsoleStatus]::Success = [ConsoleColor]::Green
        }

        # Indentation initialization
        if (-not (Test-Path Variable:Script:IndentLevel) -or $ResetIndent -or ($Script:IndentLevel -lt 0)) {
            $Script:IndentLevel = 0
        }
        if ($EndTask) {
            $Script:IndentLevel = [Math]::Max(0, $Script:IndentLevel - 1)
        }
    }

    process {
        # Handle continuation logic first 🕵️
        if (-not ($StartTask -or $EndTask -or $ResetIndent) -and $Script:ConsoleLastNoNewline) {
            # Continue previous line with just color and message
            Write-Host $Message -NoNewline:$NoNewline -ForegroundColor $colorMapping[$Status]
            $Script:ConsoleLastNoNewline = $NoNewline
            return
        }

        # Reset continuation state for structural changes 🔨
        $Script:ConsoleLastNoNewline = $false

        # Normal message processing ✨
        $Color = if ($StartTask) { [ConsoleColor]::White } else { $colorMapping[$Status] }
        
        # Build magical prefix components 🧙
        $timestamp = if ($env:WRITE_CONSOLE_INCLUDE_DATETIME -eq $true) { "$(Get-Date -Format 's') " }
        $emoji = $statusCodes[$Status]
        $prefix = "${timestamp}${emoji} "

        # Calculate indentation 🐢
        $currentIndent = if (-not $SkipIndent) { ' ' * ($Script:IndentLevel * 4) }

        # Assemble final message 🧩
        $formattedMessage = "${currentIndent}${prefix}${Message}"
        
        # Write the formatted message 🖨️
        Write-Host $formattedMessage -NoNewline:$NoNewline -ForegroundColor $Color

        # Update continuation state 🔄
        $Script:ConsoleLastNoNewline = $NoNewline

        # Handle task indentation 📈
        if ($StartTask) { $Script:IndentLevel++ }
    }
}
#endregion Helper functions
$IsAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if ($IsAdmin -or ($IsAdmin -and $ChocoOnly)) {
    if ($INSTALL_CHOCO) {
        Write-Console "Beginning 'choco' installation." -StartTask -ResetIndent
        if (-not (Get-Command 'choco' -ErrorAction SilentlyContinue)) {
            Write-Console "'choco' not found in path, installing..." -Status Info -NoNewline
            Set-ExecutionPolicy Bypass -Scope Process -Force;
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        }
        else {
            Write-Console "'choco' found in path. Updating."
            choco upgrade chocolatey -y
        }
    }

    if ($chocoPackages) {
        Write-Console 'Installing packages via chocolatey'
        foreach ($pkg in $chocoPackages) {
            choco install $pkg -y
        }
    }
    Write-Console "Chocolatey setup complete!" -Status Success -EndTask
}


Write-Console 'Beginning environment setup...' -StartTask

if (-not (Get-Command 'git')) {
    $continue = ''
    while ($continue.ToLower() -notin ('y', 'n')) {
        $continue = Read-Host -Prompt "Git not found in path. Install via scoop? (Y/N)"
    }

    if ($continue.ToLower() -eq 'y') {
        Write-Console "Installing 'scoop' and 'git'."
        Install-Scoop
        
        Write-Console "'scoop' installed."
        
        scoop install git
        
        if ($LASTEXITCODE -ne 0) {
            Write-Console "An error occurred while attempting to install git. Review the output and try again." -Status Error -EndTask
        }
        else {
            Write-Console "Git successfully installed. Bootstrap will continue." -Status Success -EndTask
        }
    }
    else {
        Write-Console "Setup stopped. Install Git and try again." -Status Error -EndTask
    }
}

# Create module path in $env:LOCALAPPDATA/PowerShell/Modules
Write-Console "Validating $env:LOCAL_DOTFILE_PATH exists..."
if (-Not (Test-Path $env:LOCAL_DOTFILE_PATH)) {
    Write-Console "Dotfile repository path '$env:LOCAL_DOTFILE_PATH` does not exist, creating..." -NoNewline
    try {
        $null = New-Item -Path $env:LOCAL_DOTFILE_PATH -ItemType Directory -ErrorAction Stop
        Write-Console 'done!' -Status Success
    }
    catch {
        Write-Console 'failed!' -Status Error
        Write-Console "Failed to create dotfile folder '$env:LOCAL_DOTFILE_PATH'"
    }
}

Write-Console "Initializing bare git repository in $env:LOCAL_DOTFILE_PATH..." -StartTask

# Run git status on the target path and redirect output to null. If the path is
# a repository, $LASTEXITCODE will be 0, otherwise it will be 128
git --git-dir "$env:LOCAL_DOTFILE_PATH" --work-tree="$HOME" status > nul 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Console "$env:LOCAL_DOTFILE_PATH is already a git repository." -Status Warn
    Write-Console 'Electing to continue will delete the repository folder, creating a new one' -Status Warn
    Write-Console 'and initialize a bare git repository.' -Status Warn
    $continue = ''
    while ($continue.ToLower() -notin ('y', 'n')) {
        $continue = Read-Host 'Continue? (y/n)'
    }

    if ($continue.ToLower() -eq 'n') {
        Write-Console 'Setup aborted.' -Status Error -ResetIndent
    }
    elseif ($continue.ToLower() -eq 'y') {
        Write-Console "Removing $env:LOCAL_DOTFILE_PATH..." -NoNewline
        try {
            $null = Remove-Item $env:LOCAL_DOTFILE_PATH -Recurse -Force -ErrorAction Stop

            Write-Console 'done!' -Status Success
        }
        catch {
            Write-Console 'failed!' -Status Error
            Write-Console 'Bootstrap failed. Review error messages and try again.' -Status Error -ResetIndent
        }
    }

    Invoke-DotfileGit config --local status.showUntrackedFiles no
    Write-Console "Bare git repository configured!" -Status Success -EndTask
}


if ($INSTALL_SCOOP) {
    Write-Console 'Beginning scoop installation.' -StartTask -ResetIndent
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Console "'scoop' not found in path, installing..." -Status Info -NoNewline
        Install-Scoop
        Write-Console '...done' -Success
    }
    else {
        Write-Console "'scoop' found in path. Updating."
        scoop update -q
    }

    if ($scoopBuckets) {
        Write-Console 'Adding buckets...'
        foreach ($bkt in $scoopBuckets) {
            scoop bucket add $bkt
        }
    }

    if ($scoopPackages) {
        Write-Console 'Installing packages...'
        foreach ($pkg in $scoopPackages) {
            scoop install $pkg
        }
    }

    Write-Console 'scoop installation finished!' -EndTask -Status Success
}

if (-not ($SkipProfileUpdate)) {
    Write-Console 'Updating powershell profile...' -StartTask

    if (-not (Test-Path $profile)) {
        Write-Console "No profile found. Creating."
        $null = New-Item $profile -ItemType File -Force
    }

    Write-Console ('Adding $env:LOCAL_DOTFILE_PATH with value: {0} to profile...' -f $env:LOCAL_DOTFILE_PATH)
    ('$env:LOCAL_DOTFILE_PATH = "{0}"' -f $env:LOCAL_DOTFILE_PATH) | Out-File $profile -Append

    Write-Console ("Adding 'Invoke-DotfileGit' function to profile...")
@'
function Invoke-DotfileGit {
    git --git-dir "$env:LOCAL_DOTFILE_PATH" --work-tree="$HOME" $args
}
'@ | Out-File $profile -Append

    Write-Console "Adding alias 'cfg' for 'Invoke-DotfileGit' to profile..."
@"
Set-Alias -Name 'cfg' -Value 'Invoke-DotfileGit'
"@ | Out-File $profile -Append
}

$msg = @"
    The bootstrap script has finished. A bare git repository has been setup in:
    
    $env:LOCAL_DOTFILE_PATH

    This repository can be interacted with using the alias 'cfg', or with the
    function 'Invoke-DotfileGit'. To add a dotfile for tracking:

    cfg add $HOME/.ssh/config

    Which is the equivalent of:

    git --git-dir "$env:LOCAL_DOTFILE_PATH" --work-tree="$HOME" add $HOME/.ssh/config

    No upstream has been configured, you will need to do that on your own.
"@ | Write-Information -InformationAction Continue
