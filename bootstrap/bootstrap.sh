#!/bin/zsh

load_tools () {
  __message "Setup initiated"
  __message "Loading remote tools: $@"
  for arg in "$@"; do 
    _load_remote_tool "$arg"
  done
}

_load_remote_tool () {
  temp="$(mktemp ./temp.sh.XXX)"
  chmod 744 "$temp"
  curl -fsSL "https://raw.githubusercontent.com/aegatlin/setup/master/tools/$1" > "$temp"
  source "$temp"
}

clean_up () {
  __message "Cleaning up"
  rm ./temp.sh.*
  rm ./bootstrap.sh
  __message "Setup complete"
}

__message () {
  echo
  echo "**********"
  echo "$1"
  echo "**********"
  echo
}

__has_command () {
  command -v $1 1> /dev/null
}

__run_command () {
  echo
  if [[ $# -eq 2 ]]; then
    echo "Executing command: $1 ($2)"
  else
    echo "Executing command: $1"
  fi

  eval $1
}