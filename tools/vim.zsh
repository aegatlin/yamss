#!/bin/zsh

vim__prepare() {
  ensure_command vim
}

vim__setup() {}

vim__augment() {
  rm -f ~/.vimrc
  curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/example.vimrc> ~/.vimrc
}

vim__bootstrap() {}
