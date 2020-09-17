#!/bin/zsh

bootstrap () {
  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/create_bootstrap.sh)"
  source ./bootstrap
}

setup () {
  load_files

  echo "do stuff"
  
  clean_up  
}

bootstrap
setup
