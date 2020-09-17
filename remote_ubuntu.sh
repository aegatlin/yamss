#!/bin/zsh

bootstrap () {
  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/bootstrap/create_bootstrap.sh)"
  source ./bootstrap.sh
}

setup () {
  load_tools "git.sh"

  git__prepare

  git__setup
  
  clean_up  
}

bootstrap
setup
