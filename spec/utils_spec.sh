Describe 'utils'
  Include lib/utils.sh

  Describe 'has_command'
    It 'returns 0 (success) when command is present on machine'
      When call has_command echo
      The status should be success
    End

    It 'returns 1 (failure) when the command is not present on the machine'
     When call has_command echp
     The status should be failure
    End
  End

  Describe 'ensure_command'
    It 'returns 0 (success) when command is present on machine'
      When call ensure_command echo
      The status should be success
    End

    It 'displays error message and exits when command is not present on machine'
      error_and_exit() { echo "no bueno: $1"; exit 1; }
      When run ensure_command echp
      The line 1 should equal "no bueno: Command not found: echp"
      The status should be failure
    End
  End

  Describe 'error_and_exit'
    It 'formats any one-line error message'
      When run error_and_exit "oops"
      The line 1 of output should equal "**********"
      The line 2 of output should equal "yamss error message: oops"
      The line 3 of output should equal "exiting"
      The line 4 of output should equal "**********"
      The status should be failure
    End
  End

  Describe 'for_each'
    It 'runs the same command for each element in the array'
      local list=(a b c)
      local c=echo
      When call for_each "$c" "${list[@]}"
      The line 1 of output should equal 'a'
      The line 2 of output should equal 'b'
      The line 3 of output should equal 'c'
    End

    It 'runs the same function for each element in the array'
      local list=(pkg1 pkg2 pkg2-dev)
      test_f() {
        echo "installing $1..."
        echo "finished installing $1"
      }
      When call for_each test_f "${list[@]}"
      The line 1 of output should equal 'installing pkg1...'
      The line 2 of output should equal 'finished installing pkg1'
      The line 3 of output should equal 'installing pkg2...'
      The line 4 of output should equal 'finished installing pkg2'
      The line 5 of output should equal 'installing pkg2-dev...'
      The line 6 of output should equal 'finished installing pkg2-dev'
    End
  End
End
