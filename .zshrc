source ~/.zplug/init.zsh

##### plugins

# Let zplug manage itself
#zplug 'zplug/zplug', hook-build:'zplug --self-manage'

## completions
zplug "zsh-users/zsh-completions", as:plugin, use:"src"

## pure
zplug "mafredri/zsh-async", on:sindresorhus/pure
zplug "sindresorhus/pure"

## tools
zplug "jhawthorn/fzy", as:command, rename-to:fzy, hook-build:"make"
zplug "peco/peco", as:command, from:gh-r
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf"
zplug "monochromegane/the_platinum_searcher", as:command, from:gh-r, rename-to:"pt"
zplug "motemen/ghq", as:command, from:gh-r, rename-to:ghq

## directory moving
zplug "b4b4r07/enhancd", use:init.sh
zplug "mollifier/cd-gitroot"

# syntax hilight. defer setting needed to load after compinit
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
zplug "b4b4r07/emoji-cli", on:"stedolan/jq"

zplug "hidetoshing/zsh-git-commands"
zplug "hidetoshing/zsh-easy-history"

# Can manage local plugins
# zplug "~/.zsh", from:local

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
zplug load

# rbenv settings
if builtin command -v rbenv > /dev/null; then
  eval "$(SHELL=zsh rbenv init -)"
fi

# plugin settings
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
export EMOJI_CLI_FILTER='fzy:fzf:peco'
export EMOJI_CLI_KEYBIND='^e'
export ENHANCD_DOT_ARG='up'

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
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias -g HOSTS='grep HostName ~/.ssh/config | cut -c12- | fzy -l 24 -p "HOSTS > "'
