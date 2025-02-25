if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH $PATH ~/bin

    # Alias for dotfile management
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    
    # Init starship prompt
    starship init fish | source
end
