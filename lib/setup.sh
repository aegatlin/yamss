CONFIG_URL='https://raw.githubusercontent.com/aegatlin/setup/master/config'

setup() {
  message 'yamss begin'
  if is_mac; then
    echo 'MacOS detected'
    load_tools zsh brew asdf nvim tmux starship
  elif is_ubuntu; then
    echo 'Linux detected'
    load_tools zsh apt asdf nvim tmux starship
  else
    message "OS detection failed: uname $(uname) not recognized"
    exit 1
  fi

  write_configs
  outro
}

outro() {
  message 'yamss end'
  message "(you should probably \`exit\` or \`reboot\` now)"
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

message() {
  printf '* %s\n**********\n' "$1"
}

has_command() {
  command -v "$1" 1> /dev/null
}
