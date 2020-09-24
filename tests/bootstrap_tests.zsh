#! /bin/zsh

source ./bootstrap/bootstrap.zsh
source ./tests/test_helpers.zsh

test_build_function_list() {
  test_message "test_build_function_list"

  local -a actual=($(build_function_list asdf zxcv))
  local -a expected=(
    "asdf__prepare"
    "zxcv__prepare"
    "asdf__setup"
    "zxcv__setup"
    "asdf__augment"
    "zxcv__augment"
    "asdf__bootstrap"
    "zxcv__bootstrap"
  )

  assert_equal $actual[1] $expected[1]
  assert_equal $actual[2] $expected[2]
  assert_equal $actual[3] $expected[3]
  assert_equal $actual[4] $expected[4]
  assert_equal $actual[5] $expected[5]
  assert_equal $actual[6] $expected[6]
  assert_equal $actual[7] $expected[7]
  assert_equal $actual[8] $expected[8]

  echo "PASSED"
}
test_build_function_list
