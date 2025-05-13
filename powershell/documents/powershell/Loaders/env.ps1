# Update path to inclide .local\bin
$env:Path = "$env:userprofile\.local\bin;$env:Path"

# Setting LOCAL_GIT_FOLDER helps with the cdg alias
$env:LOCAL_GIT_FOLDER = Join-Path -Path $env:USERPROFILE -ChildPath 'git'

# Define custom Starship config directory
$env:STARSHIP_CONFIG = Join-Path -Path $env:USERPROFILE -ChildPath '.config\starship\starship.toml'

# Define custom Komorebi config directory
$env:KOMOREBI_CONFIG_HOME = Join-Path -Path $env:USERPROFILE '.config\komorebi'
if (-not (Test-Path $env:KOMOREBI_CONFIG_HOME)) {
    New-Item -Path $env:KOMOREBI_CONFIG_HOME -ItemType directory
}

# Used for the git bare repository containing all dotfiles
$env:LOCAL_DOTFILE_PATH = (Join-Path $env:USERPROFILE -ChildPath '.dotfiles')

# Use XDG dot locations for Windows
$env:XDG_CONFIG_HOME = "$HOME/.config"
$env:XDG_DATA_HOME = "$HOME/.local/share"
$env:XDG_STATE_HOME = "$HOME/.local/state"
$env:XDG_CACHE_HOME = "$HOME/.cache"

# If espanse is installed, add an environment variable
if (Test-Path (Join-Path $env:APPDATA 'espanso')) {
    $env:ESPANSO_PATH = (Join-Path $env:APPDATA 'espanso')
}


