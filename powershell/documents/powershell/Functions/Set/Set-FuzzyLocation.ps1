function Set-FuzzyLocation {
    param (
        [string]$Path = (Get-Location)
    )

    begin {
        # Check if fzf is installed
        if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
            Write-Host 'fzf not found. Please install it first.' -ForegroundColor Red
            return
        }

        if (Get-Command 'eza' -ErrorAction SilentlyContinue) {
            $simplePrompt = $false
        }
        else {
            $simplePrompt = $true
        }
    }

    process {
        # Define a Nerd Font icon for directories
        $dirIcon = "$([char]0xf07b)"  #  (folder icon)
        $upIcon = "$([char]0xf062)"   #  (up arrow)

        # Start at the given path
        $currentPath = $Path

        while ($true) {
            # Use Get-ChildItem to list directories with Nerd Font icons
            $dirs = @('..') + (Get-ChildItem -Path $Path -Directory | ForEach-Object { $_.Name })

            # format with nf
            $formattedDirs = $dirs | ForEach-Object {
                if ($_ -eq '..') {
                    "$upIcon $_"
                }
                else {
                    "$dirIcon $_"
                }
            }

            if (-not ($formattedDirs)) { return }

            # if eza exists
            if ($simplePrompt) {
                $selected = $dirs | fzf --ansi --border --height 60% --layout=reverse --prompt=" Select a directory: "
            }
            else {
                $selected = $dirs | fzf --ansi --border --height 60% --layout=reverse --prompt=" Select a directory: " --preview="eza -T --level=2 {}"
            }

            $dirName = $selected -replace '^.+\s', ''

            if ($dirName -eq '..') {
                $currentPath = (Get-Item $currentPath).Parent.FullName
            }
            else {
                $currentPath = Join-Path -Path $currentPath -ChildPath $dirName
            }

            Set-Location -Path $currentPath
            Write-Host "`n Changed location to: $dirName" -ForegroundColor Cyan
        }
    }
}

