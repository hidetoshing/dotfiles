#!/bin/sh

echo "Installer bootstrap"

echo "  This dotfiles require vim, zsh, tmux."

git clone git@github.com:hidetoshing/dotfiles.git ~/src/github.com/hidetoshing/dotfiles

cd ~/src/github.com/hidetoshing/dotfiles
make install
make link

echo "  please run 'ln -sfnv ~/src/github.com/hidetoshing/dotfiles/resources/vim/*.toml ~/.vim/rc/' before launch vim."
echo "  for install mac applications, make brewfile."

