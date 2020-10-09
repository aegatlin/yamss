#!/bin/zsh

brew__prepare() {
  if ! is_mac; then
    error_and_exit "this machine is not a mac"
  fi

  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

brew__setup() {
  ensure_brew_install() {
    if ! brew list | grep -q "$1"; then
      run_command "brew install $1"
    fi
  }

  ensure_brew_cask_install() {
    if ! brew list --cask | grep -q "$1"; then
      run_command "brew cask install $1"
    fi
  }

  ensure_brew_install coreutils
  ensure_brew_install git
  ensure_brew_install direnv
  ensure_brew_install mosh
  ensure_brew_install gpg
  ensure_brew_install tmux

  ensure_brew_cask_install visual-studio-code
}

brew__augment() {
  cat <<'DELIMIT' >>~/.zshrc
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

brew__bootstrap() {}
