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
zplug "zsh-users/zsh-syntax-highlighting", nice:10

zplug "zsh-users/zsh-autosuggestions"


# Can manage local plugins
# zplug "~/.zsh", from:local

# additional path
path=(
    /usr/local/opt/coreutils/libexec/gnubin(N-/)
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    $path
)

manpath=(
    /usr/local/opt/coreutils/libexec/gnuman(N-/)
    $manpath
)

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
zplug load --verbose

# alias
alias ls="ls -GF"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"

