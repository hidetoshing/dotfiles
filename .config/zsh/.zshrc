# homebrew setting (Normally this command is executed by .zprofile)
# eval "$(/opt/homebrew/bin/brew shellenv)"

# zsh extentions
autoload -Uz zmv
alias zmv='noglob zmv -W'

# additional path
path=(
    $HOME/bin(N-/)
    $(brew --prefix coreutils)/libexec/gnubin(N-/)
    /usr/local/bin(N-/)
    $path
)

manpath=(
    $(brew --prefix coreutils)/libexec/gnuman(N-/)
    $manpath
)

source $XDG_CONFIG_HOME/zsh/.zshalias
source $HOME/.zshrc

# load compinit
autoload -U compinit && compinit

# plugins
source $XDG_CONFIG_HOME/zsh/.zinit
