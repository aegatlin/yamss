CONFIG_URL='https://raw.githubusercontent.com/aegatlin/setup/master/config'

setup() {
  printf "**********\nyamss setup initiated\n**********\n"
  if is_mac; then
    echo 'MacOS detected'
    load_tools zsh brew asdf nvim tmux
  elif is_ubuntu; then
    echo 'Linux detected'
    load_tools zsh apt asdf nvim tmux
  else
    error_and_exit "OS detection failed: uname $(uname) not recognized"
  fi

  write_configs
  outro
}

outro() {
  printf "**********\nyamss setup complete\n"
  if [ "$(get_shell)" = '-zsh' ]; then
    if is_mac; then
      echo "restart shell ('exit') or 'source ~/.zshrc' (currently copied to paste buffer)"
      printf 'source ~/.zshrc' | pbcopy
    else
      echo "restart shell ('exit') or 'source ~/.zshrc'"
    fi
  else
    echo "restart shell ('exit') or reboot ('sudo reboot')"
  fi
  echo '**********'
}

get_shell() {
  echo "$0"
}

is_mac() { [ "$(uname)" = 'Darwin' ]; }
is_ubuntu() { [ "$(uname)" = 'Linux' ]; }

write_configs() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/git"
  curl -fsSL ${CONFIG_URL}/git/git.config > "$HOME/.config/git/config"
}

ensure_dir() {
  if ! [ -d "$1" ]; then mkdir "$1"; fi
}

