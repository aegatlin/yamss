source ./bootstrap/bootstrap.sh

test__ensure_command () {
  # Should exit after first command
  __ensure_command blahblahblah
  __ensure_command blahblahblah
}

test__ensure_command