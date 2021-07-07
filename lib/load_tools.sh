load_tools() {
  after() {
    if ! is_member "$1" "${ran[@]}"; then
      exit 1
    fi
    return 0
  }

  run_list() {
    for f in "$@"; do
      ("$f")
      local r="$?"

      if [ "$r" = 0 ]; then
        ran+=("$f")
        try_to_empty_to_run_list
      else
        to_run+=("$f")
      fi
    done
  }

  try_to_empty_to_run_list() {
    if (( ${#to_run[@]} > 0 )); then
      ("${to_run[0]}")
      local r="$?"
      if [ "$r" = 0 ]; then
        ran+=("${to_run[0]}")
        if (( ${#to_run[@]} > 1 )); then
          to_run=("${to_run[@]:1}")
          try_to_empty_to_run_list
        else
          to_run=()
        fi
      fi
    fi
  }

  local f_list=()
  local postscripts=('__prepare' '__setup' '__augment' '__bootstrap')
  for p in "${postscripts[@]}"; do
    for tool; do
      f_list+=("$tool$p")
    done
  done

  local ran=()
  local to_run=()

  run_list "${f_list[@]}"
  run_list "${to_run[@]}"
}

is_member() {
  local elem="$1"
  shift
  local list=("$@")
  [[ "${list[*]}" =~ $elem ]]
}

is_list_empty() {
  return "$#"
}
