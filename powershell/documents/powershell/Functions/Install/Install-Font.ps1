function Install-Font {
    <#
    .SYNOPSIS
        Installs fonts with proper system registration
    .DESCRIPTION
        Handles both file copying and registry entries for font installation.
        Works for both system-wide (admin) and per-user installations.
    .PARAMETER FontPath
        Path(s) to font files or directories containing fonts
    .EXAMPLE
        Install-Font -FontPath 'C:\fonts\*.ttf' -Verbose
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$FontPath
    )

    begin {
        # Installation context detection
        $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).Groups -match 'S-1-5-32-544')
        
        # Set target paths based on admin status
        if ($isAdmin) {
            $fontDir = "$env:windir\Fonts"
            $regPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
        } else {
            $fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
            $regPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
        }

        # Create directory if needed
        if (-not (Test-Path $fontDir)) { New-Item -Path $fontDir -ItemType Directory -Force | Out-Null }

        # Get existing registry entries
        $existingRegEntries = @{}
        if (Test-Path $regPath) {
            Get-ItemProperty $regPath | Get-Member -MemberType NoteProperty | ForEach-Object {
                $existingRegEntries[$_.Name] = $true
            }
        }

        # Get existing font files
        $existingFiles = @{}
        Get-ChildItem $fontDir -Include *.ttf,*.otf,*.ttc -Recurse | ForEach-Object {
            $existingFiles[$_.Name] = $true
        }
    }

    process {
        $fontsToInstall = @()
        
        foreach ($path in $FontPath) {
            try {
                if (Test-Path $path -PathType Container) {
                    $fontsToInstall += Get-ChildItem $path -Include *.ttf,*.otf,*.ttc -Recurse -ErrorAction Stop
                }
                else {
                    $fontsToInstall += Get-Item $path -ErrorAction Stop
                }
            }
            catch {
                Write-Warning "Invalid path: $path"
            }
        }

        foreach ($font in $fontsToInstall) {
            $targetPath = Join-Path $fontDir $font.Name
            
            # Check if already installed
            $regName = switch ($font.Extension.ToLower()) {
                '.ttf' { "$($font.BaseName) (TrueType)" }
                '.otf' { "$($font.BaseName) (OpenType)" }
                '.ttc' { "$($font.BaseName) (TrueType Collection)" }
                default { $font.Name }
            }

            if ($existingFiles.ContainsKey($font.Name) -and $existingRegEntries.ContainsKey($regName)) {
                Write-Warning "Already installed: $($font.Name)"
                continue
            }

            try {
                # Copy font file
                Write-Verbose "Copying $($font.Name) to $fontDir"
                Copy-Item $font.FullName -Destination $targetPath -Force

                # Add registry entry
                if (-not $existingRegEntries.ContainsKey($regName)) {
                    Write-Verbose "Adding registry entry: $regName"
                    New-ItemProperty -Path $regPath -Name $regName -PropertyType String -Value $font.Name -Force | Out-Null
                }

                # Refresh font cache if needed
                if ($isAdmin) {
                    Write-Verbose "Updating system font cache..."
                    [void][Windows.Fonts]::AddFontResource($targetPath)
                }
            }
            catch {
                Write-Warning "Failed to install $($font.Name): $_"
                if (Test-Path $targetPath) { Remove-Item $targetPath -ErrorAction SilentlyContinue }
            }
        }
    }

    end {
        # Final verification
        Write-Verbose "Font installation completed. Log out or restart applications to see changes."
    }
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Windows {
    [DllImport("gdi32.dll")]
    public static extern int AddFontResource(string lpszFilename);
}
"@