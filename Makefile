XDG_CONFIG_HOME ?= "${HOME}/.config"
XDG_DATA_HOME ?= "${HOME}/.local/share"
USER_HOME ?= "${HOME}"

$(XDG_CONFIG_HOME)/%: ${CURDIR}/$*
	mkdir -p $(@D)
	ln -fs $< $@

$(USER_HOME)/%: ${CURDIR}/$*
	ln -fs $< $@

${CURDIR}/%:
	git pull origin master

.PHONY help:
	cat Makefile | grep '^?.:'

## uninstall settings
.PHONY clean:
	rm -r $(XDG_CONFIG_HOME)/git
	rm -r $(XDG_CONFIG_HOME)/nvim
	rm -r $(XDG_DATA_HOME)/nvim
	rm -r $(XDG_CONFIG_HOME)/tmux
	rm -r $(XDG_CONFIG_HOME)/zsh
	rm $(USER_HOME)/.zshenv
	rm $(USER_HOME)/.screen

## config all
.PHONY configure: git vim zsh tmux screen
	@echo "configured"

## zsh
.PHONY zsh: $(XDG_CONFIG_HOME)/zsh/.zshrc $(USER_HOME)/.zshenv
	@echo "zsh completed"

## bash
.PHONY bash: $(USER_HOME)/.bashrc
	@echo "bash completed"

## git
.PHONY git: $(XDG_CONFIG_HOME)/git/config $(XDG_CONFIG_HOME)/git/ignore
	@echo "git completed"

## vim
.PHONY vim: $(XDG_CONFIG_HOME)/nvim/init.vim $(XDG_DATA_HOME)/nvim/site/autoload/plug.vim
	@echo "neovim completed"

$(XDG_DATA_HOME)/nvim/site/autoload/plug.vim:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## tmux
.PHONY tmux: $(XDG_CONFIG_HOME)/tmux/tmux.conf
	git clone https://github.com/tmux-plugins/tpm $(XDG_CONFIG_HOME)/tmux/plugins/tpm
	@echo "tmux completed"

## optional
.PHONY screen: $(USER_HOME)/.screenrc
	@echo "screen completed"

