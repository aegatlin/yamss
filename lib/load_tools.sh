TOOL_SOURCES=()

load_tools() {
  after() {
    if ! is_member "$1" "${ran[@]}"; then
      exit 1
    fi
    return 0
  }

  try_to_empty_to_run_list() {
    if (( ${#to_run[@]} > 0 )); then
      ("${to_run[0]}")
      local r="$?"
      if [ "$r" = 0 ]; then
        ran+=("${to_run[0]}")
        run_sources
        if (( ${#to_run[@]} > 1 )); then
          to_run=("${to_run[@]:1}")
          try_to_empty_to_run_list
        else
          to_run=()
        fi
      fi
    fi
  }

  local ran=()
  local to_run=()
  local phases=('__prepare' '__setup' '__augment' '__bootstrap')
  for i in "${!phases[@]}"; do
    local phase="${phases[$i]}"

    local previous_phases=()
    if (("$i" > 0)); then
      previous_phases=("${phases[@]:0:i}")
    fi

    for tool; do
      # collect previous tool phases
      local previous_tool_phases=()
      for pp in "${previous_phases[@]}"; do
        previous_tool_phases+=("$tool$pp")
      done

      # if any previous tool phases are in to_run
      # also add this tool phase to to_run and skip
      local skip=false
      for ptp in "${previous_tool_phases[@]}"; do
        if [[ "${to_run[*]}" =~ $ptp ]]; then
          skip=true
        fi
      done

      local f="$tool$phase"

      if "$skip"; then
        to_run+=("$f")
      else
        # if no skip, actually run the function to see
        # if the internal after clause exits
        ("$f")
        local r="$?"
        if [ "$r" = 0 ]; then
          # if the function ran successfully
          # run any sources the function added via add_source
          # try to empty the to_run list via try_to_empty_to_run_list
          ran+=("$f")
          run_sources
          try_to_empty_to_run_list
        else
          # if the function exited in the subshell
          # the after clause disallowed running
          # so add to the to_run list for later
          to_run+=("$f")
        fi
      fi
    done
  done
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

add_source() {
  TOOL_SOURCES+=("$1")
}

run_sources() {
  # shellcheck source=/dev/null
  for t in "${TOOL_SOURCES[@]}"; do
    source "$t"
  done

  TOOL_SOURCES=()
}
