#!/bin/zsh

brew__install () {
  if ! __has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

brew__setup () {
  _brew__ensure_brew_install coreutils
  _brew__ensure_brew_install curl
  _brew__ensure_brew_install git
  _brew__ensure_brew_install direnv
  _brew__ensure_brew_install mosh
  _brew__ensure_brew_install gpg
}

_brew__ensure_brew_install () {
  if ! brew list | grep -q "$1"; then
   __run_command "brew install $1"
  fi
}

brew__augment () {
  _brew__append_to_zshrc
}

_brew__append_to_zshrc () {
cat << DELIMIT >> ~/.zshrc
##########
# brew setup
##########
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

DELIMIT
}
