has_command() {
  command -v "$1" 1>/dev/null
}

ensure_command() {
  if ! has_command "$1"; then
    error_and_exit "Command not found: $1"
  fi
}

error_and_exit() {
  echo "**********"
  echo "yamss error message: $1"
  echo "exiting"
  echo "**********"
  exit 1
}

for_each() {
  local f="$1"
  shift
  local ary=("$@")
  for e in "${ary[@]}"; do
    "$f" "$e"
  done
}
