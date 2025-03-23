if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH $PATH ~/bin

    # Alias for dotfile management
    #alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    # Init starship prompt
    starship init fish | source
    fzf --fish | source

end

# neovim
alias e nvim
alias v nvim

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Nmap
alias nm="nmap -sC -sV -oN nmap"

# Changing "ls" to "eza"
alias ls='eza -al --color=always --header --group-directories-first' # my preferred listing
alias la='eza -a --color=always --header --group-directories-first' # all files and dirs
alias ll='eza -l --color=always --header --group-directories-first' # long format
alias lt='eza -aT --color=always --header --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'
alias l.='eza -al --color=always --header --group-directories-first ../' # ls on the PARENT directory
alias l..='eza -al --color=always --header --group-directories-first ../../' # ls on directory 2 levels up
alias l...='eza -al --color=always --header --group-directories-first ../../../' # ls on directory 3 levels up

# pacman and yay
alias pacsyu='sudo pacman -Syu' # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu' # Refresh pkglist & update standard pkgs

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Network shortcuts/aliases and utilities
alias ip "dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
alias ipl "ipconfig getifaddr en0" #internal network IP
alias ips "ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
alias sniff "sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias whois "grc whois" # colorized whois

# SSH and localhost
alias hostfile 'eval sudo $EDITOR /etc/hosts'
alias editssh 'eval $EDITOR ~/.ssh'
alias lssh 'grep -w -i Host ~/.ssh/config | sed s/Host//'
