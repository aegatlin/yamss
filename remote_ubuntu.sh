#!/bin/zsh

bootstrap () {
  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/bootstrap/create_bootstrap.sh)"
  source ./bootstrap.sh
}

setup () {
  load_tools

  echo "do stuff"
  
  clean_up  
}

bootstrap
setup
