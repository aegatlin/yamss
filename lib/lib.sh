setup() {
  printf "**********\nyamss setup initiated\n**********\n"
  if [ "$(uname)" = 'Darwin' ]; then
    echo 'MacOS detected'
    setup_mac
  elif [ "$(uname)" = 'Linux' ]; then
    echo 'Linux detected'
    setup_linux
  else
    error_and_exit "OS detection failed: uname $(uname) not recognized"
  fi

  write_configs
  outro
}

outro() {
  printf "**********\nyamss setup complete\n"
  if [ "$(get_shell)" = '-zsh' ]; then
    if [ "$(uname)" = 'Darwin' ]; then
      echo "Restart shell or 'source ~/.zshrc' (currently copied to paste buffer)"
      printf 'source ~/.zshrc' | pbcopy
    fi
  else
    echo 'Restart shell'
  fi
  echo '**********'
}

get_shell() {
  echo "$0"
}

setup_mac() {
  load_tools zsh brew asdf
}

setup_linux() {
  load_tools zsh apt asdf
}

write_configs() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/nvim"
  ensure_dir "$HOME/.config/git"
  ensure_dir "$HOME/.config/tmux"

  local ROOT_PATH='https://raw.githubusercontent.com/aegatlin/setup/master/'
  curl -fsSL ${ROOT_PATH}lib/configs/init.lua > "$HOME/.config/nvim/init.lua"
  curl -fsSL ${ROOT_PATH}lib/configs/git.config > "$HOME/.config/git/config"
  curl -fsSL ${ROOT_PATH}lib/configs/tmux.conf > "$HOME/.config/tmux/tmux.conf"
}

ensure_dir() {
  if ! [ -d "$1" ]; then mkdir "$1"; fi
}

load_tools() {
  local postscripts=('__prepare' '__setup' '__augment' '__bootstrap')
  for p in "${postscripts[@]}"; do
    for tool; do
      "$tool$p"
    done
  done
}

has_command() {
  command -v "$1" 1>/dev/null
}

ensure_command() {
  if ! has_command "$1"; then
    error_and_exit "Command not found: $1"
  fi
}

run_command() {
  echo "$1"
  eval "$1"
}

error_and_exit() {
  echo "**********"
  echo "yamss error message: $1"
  echo "exiting"
  echo "**********"
  exit 1
}

