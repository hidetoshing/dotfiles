
XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
USER_HOME ?= ${HOME}

## symlink rule
$(USER_HOME)/%: ${CURDIR}/%
	mkdir -p $(@D)
	ln -fs $^ $@

## config rule
.PRECIOUS ${CURDIR}/%:
	touch $@

## help
help:
	cat Makefile | grep '^?.:'

## cean
## - cleanup config w/o bashrc
clean:
	rm -fr $(XDG_CONFIG_HOME)/git
	rm -fr $(XDG_CONFIG_HOME)/nvim
	rm -fr $(XDG_DATA_HOME)/nvim
	rm -fr $(XDG_CONFIG_HOME)/tmux
	rm -fr $(XDG_CONFIG_HOME)/zsh
	rm -fr $(XDG_CONFIG_HOME)/wezterm
	rm $(USER_HOME)/.screenrc
	rm $(USER_HOME)/.zshenv
	rm $(USER_HOME)/.screen

## configure
## - config all
configure: zsh git wezterm vim tmux screen
	@echo "configured"


## install from homebrew
brew-install:
	if ! command -v gh &> /dev/null; then brew install gh; fi
	if ! command -v rg &> /dev/null; then brew install ripgrep; fi
	if ! command -v fd &> /dev/null; then brew install fd; fi
	if ! command -v fzf &> /dev/null; then brew install fzf; fi
	if ! command -v gls &> /dev/null; then brew install coreutils; fi
	if ! command -v tmux &> /dev/null; then brew install tmux; fi
	if ! command -v npm &> /dev/null; then brew install npm; fi
	if ! command -v tree-sitter &> /dev/null; then brew install tree-sitter-cli tree-sitter; fi
	if ! command -v luajit &> /dev/null; then brew install luajit luarocks lua-language-server; fi
	if ! command -v nvim &> /dev/null; then brew install --HEAD neovim; fi

brew-install-weaterm:
	brew install --cask wezterm

## zsh
zsh: $(XDG_CONFIG_HOME)/zsh/.zshrc $(XDG_CONFIG_HOME)/zsh/.zshalias $(XDG_CONFIG_HOME)/zsh/.zprofile $(XDG_CONFIG_HOME)/zsh/.zinit $(USER_HOME)/.zshenv
	@echo "zsh completed"

wezterm: $(XDG_CONFIG_HOME)/wezterm/wezterm.lua
	@echo "zsh completed"

## bash not install by configure
bash: $(USER_HOME)/.bashrc
	@echo "bash completed"

## git
git: $(XDG_CONFIG_HOME)/git/config $(XDG_CONFIG_HOME)/git/ignore
	@echo "git completed"

## vim
vim: $(XDG_CONFIG_HOME)/nvim/init.lua
	ln -fs ${CURDIR}/.config/nvim/lua $(XDG_CONFIG_HOME)/nvim/lua
	ln -fs ${CURDIR}/.config/nvim/after $(XDG_CONFIG_HOME)/nvim/after
	ln -fs ${CURDIR}/.config/nvim/lsp $(XDG_CONFIG_HOME)/nvim/lsp
	@echo "neovim completed"

## tmux
tmux: $(XDG_CONFIG_HOME)/tmux/tmux.conf
	git clone https://github.com/tmux-plugins/tpm $(XDG_CONFIG_HOME)/tmux/plugins/tpm
	@echo "tmux completed"

## optional
screen: $(USER_HOME)/.screenrc
	@echo "screen completed"

