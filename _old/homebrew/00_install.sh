#!/bin/sh

echo "install xcode command line tools"
xcode-select: note: install requested for command line developer tools

echo "install homebrew"
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

brew doctor
brew update

