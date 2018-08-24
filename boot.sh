#!/bin/sh

echo "Installer bootstrap"

# ssh key create
if [ ! -e ~/.ssh/id_rsa ]; then
    echo "Create ssh key"
    ssh-keygen -t rsa -b 4096
fi

# homebrew for mac
if ! which brew > /dev/null 3>&1; then
    echo "install homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

git clone git@github.com:hidetoshing/dotfiles.git ~/src/github.com/hidetoshing/dotfiles

echo "This dotfiles require vim, zsh, tmux."
echo "  make install"
echo "  "
echo "  please run 'ln -sfnv ~/src/github.com/hidetoshing/dotfiles/resources/vim/*.toml ~/.vim/rc/' before launch vim."
echo "  for install mac applications, make brewfile."

