setup() {
  printf "**********\nyamss setup initiated\n**********\n"
  if [ "$(uname)" = 'Darwin' ]; then
    echo 'MacOS detected'
    setup_mac
    write_configs
  elif [ "$(uname)" = 'Linux' ]; then
    echo 'Linux detected'
    setup_linux
    write_configs
  else
    error_and_exit "OS detection failed: uname $(uname) not recognized"
  fi
  printf "**********\nyamss setup completed\n**********\n"
  printf "Restart shell or 'source ~/.zshrc' to complete setup\n"
}

setup_mac() {
  load_tools zsh brew asdf direnv
}

setup_linux() {
  load_tools zsh apt snap asdf direnv
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
  for tool; do
    local tool_functions=(
      "${tool}__prepare"
      "${tool}__setup"
      "${tool}__augment"
      "${tool}__bootstrap"
    )
    for f in "${tool_functions[@]}"; do $f; done
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

