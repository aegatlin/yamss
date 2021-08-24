tmux__prepare() {
  message 'tmux__prepare'
}

tmux__setup() {
  after asdf__setup
  if is_mac; then after brew__prepare; fi

  message 'tmux__setup'

  if is_mac; then
    brew_helper_install automake
  fi

  if is_ubuntu; then
    apt_helper_install ncurses-dev build-essential \
      bison pkg-config zip unzip automake
  fi

  asdf_helper_plugin_add tmux
  asdf install tmux latest
  asdf global tmux "$(asdf latest tmux)"
}

tmux__augment() {
  message 'tmux_augment'

  ensure_config_dir tmux
  config_put tmux/tmux.conf
}

tmux__bootstrap() {
  message 'tmux__bootstrap'
}
