
# plugin settings
export EMOJI_CLI_FILTER='fzf'
export EMOJI_CLI_KEYBIND='^e'
export ENHANCD_DOT_ARG='up'

# extentions
autoload -Uz zmv
alias zmv='noglob zmv -W'

# additional path
path=(
    $HOME/bin(N-/)
    /usr/local/opt/coreutils/libexec/gnubin(N-/)
    /usr/local/bin(N-/)
    $path
)

manpath=(
    /usr/local/opt/coreutils/libexec/gnuman(N-/)
    $manpath
)

# Add color to ls command
#export CLICOLOR=1
alias ls="ls --color"
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -lha"

alias tree="exa -T"

#alias -g HOSTS='grep "^Host" ~/.ssh/config | cut -c6- | fzf --reverse --height=24 --select-1 --prompt="HOST > "'

alias vim="nvim"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# plugins

## prompt
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

## tools
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin
export FZF_DEFAULT_OPTS="--border"
export FZF_ALT_C_OPTS="--select-1 --exit-0"

zinit ice from"gh-r" as"program" pick"pt*/pt"
zinit load monochromegane/the_platinum_searcher

zinit ice from"gh-r" as"program" pick"ghq_*/ghq"
zinit load x-motemen/ghq

zinit ice from"gh-r" as"program" mv"jq* -> jq"
zinit load stedolan/jq

zinit ice from"gh-r" as"program" pick"gh_*/bin/gh"
zinit load cli/cli

zinit ice from"gh-r" as"program" mv"exa* -> exa"
zinit load ogham/exa

zinit ice from"gh-r" as"program" pick"bat-*/bat"
zinit load sharkdp/bat

## directory moving
zinit light b4b4r07/enhancd

# syntax hilight. defer setting needed to load after compinit
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

zinit ice wait'0'; zinit load "b4b4r07/emoji-cli"

zinit light "hidetoshing/zsh-git-commands"
zinit light "hidetoshing/zsh-easy-history"
zinit light "hidetoshing/zsh-cd-util"

