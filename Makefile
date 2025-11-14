XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
USER_HOME ?= ${HOME}

$(USER_HOME)/%: ${CURDIR}/%
	mkdir -p $(@D)
	ln -fs $^ $@

.PRECIOUS ${CURDIR}/%:
	touch $@

help:
	cat Makefile | grep '^?.:'

## clean
## - cleanup config w/o bashrc
clean:
	rm -r $(XDG_CONFIG_HOME)/git
	rm -r $(XDG_CONFIG_HOME)/nvim
	rm -r $(XDG_DATA_HOME)/nvim
	rm -r $(XDG_CONFIG_HOME)/tmux
	rm -r $(XDG_CONFIG_HOME)/zsh
	rm $(USER_HOME)/.zshenv
	rm $(USER_HOME)/.screen

## configure
## - config all
configure: zsh bash git vim tmux screen
	@echo "configured"


## install from homebrew
brew-install:
	if ! command -v gh &> /dev/null; then brew install gh; fi
	if ! command -v rg &> /dev/null; then brew install ripgrep; fi
	if ! command -v fzf &> /dev/null; then brew install fzf; fi
	if ! command -v gls &> /dev/null; then brew install coreutils; fi
	if ! command -v tmux &> /dev/null; then brew install tmux; fi
	if ! command -v npm &> /dev/null; then brew install npm; fi
	if ! command -v nvim &> /dev/null; then brew install --HEAD tree-sitter luajit neovim; fi
	if ! command -v bat &> /dev/null; then brew install bat; fi

## zsh
zsh: $(XDG_CONFIG_HOME)/zsh/.zshrc $(XDG_CONFIG_HOME)/zsh/.zshalias $(XDG_CONFIG_HOME)/zsh/.zprofile $(XDG_CONFIG_HOME)/zsh/.zinit $(USER_HOME)/.zshenv
	@echo "zsh completed"

## bash
bash: $(USER_HOME)/.bashrc
	@echo "bash completed"

## git
git: $(XDG_CONFIG_HOME)/git/config $(XDG_CONFIG_HOME)/git/ignore
	@echo "git completed"

## vim
vim: $(XDG_CONFIG_HOME)/nvim/init.vim $(XDG_DATA_HOME)/nvim/site/autoload/plug.vim
	mkdir -p $(XDG_DATA_HOME)/nvim/plugged
	@echo "neovim completed"

$(XDG_DATA_HOME)/nvim/site/autoload/plug.vim:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## tmux
tmux: $(XDG_CONFIG_HOME)/tmux/tmux.conf
	git clone https://github.com/tmux-plugins/tpm $(XDG_CONFIG_HOME)/tmux/plugins/tpm
	@echo "tmux completed"

## optional
screen: $(USER_HOME)/.screenrc
	@echo "screen completed"

