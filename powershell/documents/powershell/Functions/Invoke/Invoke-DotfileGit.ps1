function Invoke-DotfileGit {
    <#
    .SYNOPSIS
        Used for managing .dotfiles using a bare git repo. Saves on typing
    #>
    git --git-dir "$env:LOCAL_DOTFILE_PATH" --work-tree="$HOME" $args
}