XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
USER_HOME ?= ${HOME}

$(XDG_CONFIG_HOME)/%: ${CURDIR}/%
	mkdir -p $(@D)
	ln -fs $^ $@

$(XDG_CONFIG_HOME)/%: ${CURDIR}/%

$(USER_HOME)/%: ${CURDIR}/%
	ln -fs $< $@

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

## brew
homebrew: /usr/local/bin/brew
	@echo "install homebrew completed"

/usr/local/bin/brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## zsh
zsh: $(XDG_CONFIG_HOME)/zsh/.zshrc $(XDG_CONFIG_HOME)/zsh/alias $(USER_HOME)/.zshenv
	@echo "zsh completed"

## bash
bash: $(USER_HOME)/.bashrc
	@echo "bash completed"

## git
git: $(XDG_CONFIG_HOME)/git/config $(XDG_CONFIG_HOME)/git/ignore
	@echo "git completed"

## vim
vim: $(XDG_CONFIG_HOME)/nvim/init.vim $(XDG_DATA_HOME)/nvim/site/autoload/plug.vim
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

