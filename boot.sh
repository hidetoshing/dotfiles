#!/bin/sh

echo "Installer bootstrap"

echo "Create ssh key"

ssh-keygen -t rsa -b 4096

echo "install homebrew"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


git clone git@github.com:hidetoshing/dotfiles.git ~/src/github.com/hidetoshing/dotfiles

cd ~/src/github.com/hidetoshing/dotfiles

echo "This dotfiles require vim, zsh, tmux."
echo "  make install"
echo "  "
echo "  please run 'ln -sfnv ~/src/github.com/hidetoshing/dotfiles/resources/vim/*.toml ~/.vim/rc/' before launch vim."
echo "  for install mac applications, make brewfile."

