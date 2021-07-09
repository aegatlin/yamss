starship__prepare() {
  message 'startship__prepare'
}

starship__setup() {
  message 'startship__setup'
  after asdf__setup

  # only the "frontend" needs to have access to the appropriate fonts
  # for blink.sh on mobile devices, you do it through the UI
  # for iterm2 on mac, it is also through the UI, and is saved in config
  if is_mac; then
    brew tap homebrew/cask-fonts
    brew install font-fira-code-nerd-font
  fi

  asdf_helper_plugin_add starship
  asdf install starship latest
  asdf global starship "$(asdf latest starship)"
}

starship__augment() {
  message 'startship__augment'
  after zsh__augment

  cat << 'DELIMIT' >> ~/.zshrc
##########
# starship
##########
eval "$(starship init zsh)"

DELIMIT
}

starship__bootstrap() {
  message 'startship__bootstrap'
}
