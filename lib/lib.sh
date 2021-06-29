UNSET_LIST=(
  tool_functions
  TOOLS_PATH
  remote_tool_url
  TEMP_FILES
  current_tool_file
  ROOT_PATH
)
TEMP_FILES=()
ROOT_PATH='https://raw.githubusercontent.com/aegatlin/setup/master/'

# Setup

setup() {
  echo "**********\nyamss setup initiated\n**********"
  if [ $(uname) = 'Darwin' ]; then
    echo 'MacOS detected. Running local MacOS setup.'
    setup_mac
    write_configs
    clean_up
  elif [ $(uname) = 'Linux' ]; then
    echo 'Linux detected. Running remote Linux setup.'
    setup_linux
    write_configs
    clean_up
  else
    error_and_exit "OS detection failed: uname $(uname) not recognized"
  fi
  echo "**********\nyamss setup completed\n**********"
}

setup_mac() {
  load_tools zsh brew asdf direnv
}

setup_linux() {
  load_tools zsh apt snap asdf direnv
}

# currently untested!
write_configs() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/nvim"
  ensure_dir "$HOME/.config/git"
  ensure_dir "$HOME/.config/tmux"

  curl -fsSL ${ROOT_PATH}lib/configs/init.lua > "$HOME/.config/nvim/init.lua"
  curl -fsSL ${ROOT_PATH}lib/configs/git.config > "$HOME/.config/git/config"
  curl -fsSL ${ROOT_PATH}lib/configs/tmux.conf > "$HOME/.config/tmux/tmux.conf"
}

ensure_dir() {
  if ! [ -d "$1" ]; then mkdir $1; fi
}

# Tools

load_tools() {
  for tool; do
    set_remote_tool_url $tool
    load_tool $tool
    set_tool_functions $tool
    exec_tool_functions
  done
}

load_tool() {
  create_tool_file $1
  write_and_source_tool_file
}

create_tool_file() {
  current_tool_file=$1.temp.sh
  TEMP_FILES+=($current_tool_file)
  touch $current_tool_file
}

# Currently untested!
write_and_source_tool_file() {
  curl -fsSL $remote_tool_url > $current_tool_file
  source $current_tool_file
}

set_tool_functions() {
  tool_functions=("$1__prepare" "$1__setup" "$1__augment" "$1__bootstrap")
}

exec_tool_functions() {
  for f in "${tool_functions[@]}"; do $f; done
}

set_remote_tool_url() {
  remote_tool_url=${ROOT_PATH}lib/tools/$1.sh
}

# Helpers

has_command() {
  command -v $1 1>/dev/null
}

ensure_command() {
  if ! has_command "$1"; then
    error_and_exit "Command not found: $1"
  fi
}

run_command() {
  echo $1
  eval $1
}

clean_up() {
  for f in ${TEMP_FILES[@]}; do rm $f; done
  for v in ${UNSET_LIST[@]}; do unset $v; done
  unset UNSET_LIST
}

error_and_exit() {
  echo
  echo "**********"
  echo "ERROR"
  echo "Error message: $1"
  echo
  echo "Running clean up and exiting"
  echo "**********"
  clean_up
  exit 1
}

