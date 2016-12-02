source ~/.zplug/init.zsh

##### plugins

# Let zplug manage itself
zplug "zplug/zplug"

## completions
zplug "zsh-users/zsh-completions", as:plugin, use:"src"

## pure
zplug "mafredri/zsh-async", on:sindresorhus/pure
zplug "sindresorhus/pure"

## fzy
zplug "jhawthorn/fzy", \
    as:command, \
    rename-to:fzy, \
    hook-build:"
    {
        make
        sudo make install
    }"

## directory moving
zplug "b4b4r07/enhancd", use:init.sh
zplug "mollifier/cd-gitroot"

# syntax hilight. nice:10 needed to load after compinit
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", nice:10

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
zplug load --verbose

# plugin settings
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
export EMOJI_CLI_FILTER='fzy:fzf:peco'
export EMOJI_CLI_KEYBIND='^e'
export ENHANCD_DOT_ARG='up'

# additional path
path=(
    $HOME/bin(N-/)
    $HOME/local/bin(N-/)
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

