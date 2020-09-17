#!/bin/zsh

bootstrap () {
  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/bootstrap/create_bootstrap.sh)"
  source ./bootstrap.sh
}

setup () {
  load_tools "asdf.sh" "brew.sh" "direnv.sh" "git.sh" "zsh.sh"
 
  brew__install
  asdf__install

  brew__setup
  git__setup
  asdf__setup

  zsh__augment
  brew__augment
  direnv__augment
  asdf__augment

  zsh__initiate

  clean_up
}

bootstrap
setup