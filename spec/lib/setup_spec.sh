Describe 'lib'
  Include lib/setup.sh

  Describe 'setup'
    load_tools() { echo 'load tools'; }
    outro() { echo 'outro'; }

    It 'informs the user at the start and finish'
      uname() { echo 'Darwin'; }
      When call setup
      The line 1 should equal '* yamss begin'
      The line 2 should equal '**********'
      The line 5 should equal 'outro'
    End

    It 'calls setup_mac and clean_up when on mac'
      uname() { echo 'Darwin'; }
      When call setup
      The line 3 should equal 'MacOS detected'
      The line 4 should equal 'load tools'
    End

    It 'calls setup_linux and clean_up when on linux'
      uname() { echo 'Linux'; }
      When call setup
      The line 3 should equal 'Linux detected'
      The line 4 should equal 'load tools'
    End
  End

  Describe 'outro'
    It 'prints outro information'
      When call outro
      The line 1 should equal '* yamss end'
      The line 2 should equal '**********'
      The line 3 should equal '* (you should probably `exit` or `reboot` now)'
      The line 2 should equal '**********'
    End
  End

  Describe 'get_shell'
    It 'returns the shell environment'
      When call get_shell
      The output should equal '/bin/sh' # default shellspec environment
    End
  End

  Describe 'ensure_dir'
    It 'does nothing if the dir already exists'
      mkdir temp
      When call ensure_dir temp
      The path temp should be exist
      rm -rf temp
    End

    It 'creates a dir if the dir does not exist'
      rm -rf temp
      When call ensure_dir temp
      The path temp should be exist
      rm -rf temp
    End
  End

  Describe 'ensure_config_dir'
    It 'creates a dir in the config dir'
      When call ensure_config_dir test_dir
      The path "$HOME/.config/test_dir" should be exist
      rm -rf $HOME/.config/test_dir
    End
  End

  Describe 'config_put'
    # I'm testing that the URL passed in to curl is written
    # to the desired config file. It's a hacky way to test
    # that (a) the url is configured correctly, and (b) that
    # the file is written to appropriately
    It 'writes config files from remote to local'
      curl() { echo "$2"; }
      f() {
        ensure_config_dir test # is _always_ called before config_put
        config_put test/config
        cat "$HOME/.config/test/config"
      }
      When call f
      The path "$HOME/.config/test/config" should be exist
      The output should equal "$CONFIG_URL/test/config"
      rm -rf $HOME/.config/test
    End
  End

  Describe 'is_mac'
    It 'is true in if-clauses for mac'
      uname() { echo 'Darwin'; }
      f() { if is_mac; then echo 'yes'; fi; }
      When call f
      The output should equal 'yes'
    End

    It 'is false in if-caluses for linux'
      uname() { echo 'Linux'; }
      f() { if is_mac; then echo 'wrong'; else echo 'right'; fi; }
      When call f
      The output should equal 'right'
    End
  End

  Describe 'is_ubuntu'
    It 'is true in if-clauses for ubuntu'
      uname() { echo 'Linux'; }
      f() { if is_ubuntu; then echo 'yes'; fi; }
      When call f
      The output should equal 'yes'
    End

    It 'is false in if-caluses for mac'
      uname() { echo 'Darwin'; }
      f() { if is_ubuntu; then echo 'wrong'; else echo 'right'; fi; }
      When call f
      The output should equal 'right'
    End
  End
  
  Describe 'message'
    It 'prints a single-line message wrapper in *'
      When call message 'brew__prepare'
      The line 1 should equal '* brew__prepare'
      The line 2 should equal '**********'
    End
  End

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
End
