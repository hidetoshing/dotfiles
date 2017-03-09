DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

help:
	cat Makefile

homebrew:
	@$(foreach val, $(wildcard ./homebrew/*.sh), bash $(val);)

link:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

install:
	@$(foreach val, $(wildcard ./installer/*.sh), bash $(val);)

.PONEY: help homebrew link install

