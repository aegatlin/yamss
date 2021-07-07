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
      else
        to_run+=("$f")
      fi
    done
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
