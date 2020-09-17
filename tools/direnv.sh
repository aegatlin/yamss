#!/bin/zsh

direnv__augment () {
  __message "direnv__augment"
  _direnv__append_to_zshrc
}

_direnv__append_to_zshrc () {
cat << DELIMIT >> ~/.zshrc
##########
# direnv setup
##########
eval "$(direnv hook zsh)"

DELIMIT
}
