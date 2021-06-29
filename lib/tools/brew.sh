brew__prepare() {
  ensure_command /bin/bash

  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

brew__setup() {
  ensure_command brew

  ensure_brew_install() {
    if ! brew list --formula | grep -q "$1"; then
      run_command "brew install $1"
    fi
  }

  ensure_brew_cask_install() {
    if ! brew list --cask | grep -q "$1"; then
      run_command "brew cask install $1"
    fi
  }

  ensure_brew_install git
  ensure_brew_install mosh
  ensure_brew_install gpg
  ensure_brew_install imagemagick
  ensure_brew_cask_install visual-studio-code
  ensure_brew_cask_install iterm2
  ensure_brew_cask_install shiftit
  ensure_brew_cask_install karabiner-elements
  ensure_brew_cask_install firefox
}

brew__augment() {
  cat <<'DELIMIT' >>~/.zshrc
##########
# brew setup
##########
if type brew &>/dev/null; then
  # for zsh completions, append brew completion functions location to FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

DELIMIT
}

brew__bootstrap() { :; }
