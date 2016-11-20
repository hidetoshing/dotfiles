DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

help:
	cat Makefile

link:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

install:
	mkdir -p $(HOME)/local/src/github.com
	mkdir -p $(HOME)/local/bin
	@$(foreach val, $(wildcard ./init/*.sh), bash $(val);)

