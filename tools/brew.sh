brew__prepare() {
  message 'brew__prepare'

  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

brew__setup() {
  message 'brew__setup'

  brew_helper_install git

  # required to asdf install nodejs properly
  brew_helper_install gpg

  # casks/apps I use regularly
  brew_helper_install iterm2 firefox signal telegram slack bitwarden \
    visual-studio-code zoom

  # command line tools I like
  brew_helper_install mosh tree imagemagick
}

brew__augment() {
  message 'brew__augment'

  cat << 'DELIMIT' >> ~/.zshrc
##########
# brew setup
##########
if type brew &>/dev/null; then
  # for zsh completions, append brew completion functions location to FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

DELIMIT
}

brew__bootstrap() {
  message 'brew__bootstrap'
}

brew_helper_install() {
  for package in "$@"; do
    if ! brew list | grep -q "$package"; then
      brew install "$package"
    fi
  done
}
