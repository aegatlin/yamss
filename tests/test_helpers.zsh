#! /bin/zsh

test_message() {
  echo
  echo "**********"
  echo "* $1"
  echo "**********"
  echo
}

assert_equal() {
  if ! [ "$1" = "$2" ]; then
    echo "FAILED"
    echo "The following are NOT equal:"
    echo "  => $1"
    echo "  => $2"
    echo
    exit
  fi
}
