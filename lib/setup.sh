CONFIG_URL='https://raw.githubusercontent.com/aegatlin/setup/master/config'
CONFIG_FOLDER="$HOME/.config"

# current setup assumptions:
#   - git is pre-installed
setup() {
  message 'yamss begin'
  if is_mac; then
    echo 'MacOS detected'
    load_tools git zsh brew asdf nvim tmux starship
  elif is_ubuntu; then
    echo 'Linux detected'
    load_tools git zsh apt asdf nvim tmux starship
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

ensure_config_dir() {
  ensure_dir "$CONFIG_FOLDER"
  ensure_dir "$CONFIG_FOLDER"/"$1"
}

config_put() {
  curl -fsSL "$CONFIG_URL"/"$1" > "$CONFIG_FOLDER/$1"
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
