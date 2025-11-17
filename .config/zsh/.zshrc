# homebrew setting (Normally this command is executed by .zprofile)
# eval "$(/opt/homebrew/bin/brew shellenv)"

autoload -Uz zmv
alias zmv='noglob zmv -W'

# pyenv
export PYENV_ROOT=$(pyenv root)

# additional path
path=(
    $PYENV_ROOT/bin(N-/)
    $HOME/.nodebrew/current/bin(N-/)
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
if [[ -f $HOME/.zshrc ]]; then
    source $HOME/.zshrc
fi

# load compinit
autoload -U compinit && compinit

# plugins
source $XDG_CONFIG_HOME/zsh/.zinit

