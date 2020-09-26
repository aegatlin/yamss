#!/bin/zsh

load() {
  message "Setup initiated"
  load_tools "$@"
  local function_list=($(build_function_list $@))
  run_functions $function_list
  clean_up
}

clean_up() {
  message "Cleaning up"
  rm -f ./temp.zsh.*
  rm -f ./bootstrap.zsh
  message "Setup complete"
  echo
}

##########
# Tool helper functions
##########

run_functions() {
  message "Running functions..."
  for func in $@; do
    echo "$func"
    $func
  done
}

build_function_list() {
  local postscripts=(
    "__prepare"
    "__setup"
    "__augment"
    "__bootstrap"
  )

  local function_list=()

  for ((i = 1; i <= 4; i++)); do
    postscript=$postscripts[$i]
    for tool in $@; do
      function_list+="$tool$postscript"
    done
  done

  echo $function_list
}

load_tools() {
  load_remote_tool() {
    temp="$(mktemp ./temp.zsh.XXX)"
    chmod 744 "$temp"
    curl -fsSL "https://raw.githubusercontent.com/aegatlin/setup/master/tools/$1.zsh" >"$temp"
    source "$temp"
  }

  message "Loading remote tools..."
  for tool in "$@"; do
    echo "$tool"
    load_remote_tool "$tool"
  done
}

##########
# Command helper functions
##########

has_command() {
  command -v $1 1>/dev/null
}

run_command() {
  echo
  if [[ $# -eq 2 ]]; then
    echo "Executing command: $1 ($2)"
  else
    echo "Executing command: $1"
  fi

  eval $1
}

ensure_command() {
  if ! has_command "$1"; then
    error_and_exit "The following command is not on this machine: $1"
  fi
}

##########
# Messaging helper functions
##########

message() {
  echo
  echo "**********"
  echo "$1"
  echo "**********"
}

error_and_exit() {
  echo
  echo "**********"
  echo "ERROR"
  echo
  echo "Error message: $1"
  echo
  echo "Running clean_up before exiting early"
  echo "**********"
  clean_up
  exit
}

##########
# OS helper functions
##########

is_mac() {
  [[ uname -eq "Darwin" ]]
}

is_linux() {
  [[ uname -eq "Linux" ]]
}
