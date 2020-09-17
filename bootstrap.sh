#!/bin/zsh

load_tools () {
  for arg in "$@"; do 
    _load_remote_file "$arg"
  done
}

_load_remote_tool () {
  temp="$(mktemp ./temp.sh.XXX)"
  chmod 744 "$temp"
  curl -fsSL "https://raw.githubusercontent.com/aegatlin/notes/master/tools/$1" > "$temp"
  source "$temp"
}

clean_up () {
  rm ./temp.sh.*
  rm ./bootstrap.sh
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
  echo
}