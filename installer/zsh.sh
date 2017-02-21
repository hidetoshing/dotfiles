#!/bin/sh

echo "install zplug"
curl -sL zplug.sh/installer | zsh

echo "setup zsh"
cat << EOT > ~/.zshrc
source ~/.zplug/init.zsh

# plugins


# Can manage local plugins
# zplug "~/.zsh", from:local

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
EOT

