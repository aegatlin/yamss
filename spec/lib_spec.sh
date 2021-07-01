Describe 'lib'
  Include lib/lib.sh

  Describe 'setup'
    setup_mac() { echo 'setup mac'; }
    setup_linux() { echo 'setup linux'; }
    write_configs() { echo 'wrote configs'; }
    outro() { echo 'outro'; }

    It 'informs the user at the start and finish'
      uname() { echo 'Darwin'; }
      When call setup
      The line 1 should equal '**********'
      The line 2 should equal 'yamss setup initiated'
      The line 3 should equal '**********'
      The line 7 should equal 'outro'
    End

    It 'calls setup_mac, write_configs, and clean_up when on mac'
      uname() { echo 'Darwin'; }
      When call setup
      The line 4 should equal 'MacOS detected'
      The line 5 should equal 'setup mac'
      The line 6 should equal 'wrote configs'
    End

    It 'calls setup_linux, write_configs, and clean_up when on linux'
      uname() { echo 'Linux'; }
      When call setup
      The line 4 should equal 'Linux detected'
      The line 5 should equal 'setup linux'
      The line 6 should equal 'wrote configs'
    End
  End

  Describe 'outro'
    It 'prints outro information'
      When call outro
      The line 1 should equal '**********'
      The line 2 should equal 'yamss setup complete'
      The line 4 should equal '**********'
    End

    Context 'on macos'
      uname() { echo 'Darwin'; }

      It 'when shell is not zsh, recommend shell restart'
        get_shell() { echo '-bash'; }
        When call outro
        The line 3 should equal 'Restart shell'
      End

      It 'when shell is zsh, recommend restart or sourcing config with string place in the paste buffer'
        get_shell() { echo '-zsh'; }
        When call outro
        The line 3 should equal "Restart shell or 'source ~/.zshrc' (currently copied to paste buffer)"

        # only testing on macos machines
        unset -f uname
        if [ "$(uname)" = 'Darwin' ]; then
          local paste=$(pbpaste)
          The variable paste should equal 'source ~/.zshrc'
        fi
      End
    End

    Context 'on linux'
      uname() { echo 'Linux'; }

      It 'when shell is not zsh, recommend shell restart'
        get_shell() { echo '-bash'; }
        When call outro
        The line 3 should equal 'Restart shell'
      End
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

  Describe 'load_tools'
    It 'calls tool functions on a list of tools in the appropriate order'
      zsh__prepare() { echo 'zp'; }
      zsh__setup() { echo 'zs'; }
      zsh__augment() { echo 'za'; }
      zsh__bootstrap() { echo 'zb'; }
      brew__prepare() { echo 'bp'; }
      brew__setup() { echo 'bs'; }
      brew__augment() { echo 'ba'; }
      brew__bootstrap() { echo 'bb'; }
      When call load_tools zsh brew
      The line 1 should equal 'zp'
      The line 2 should equal 'bp'
      The line 3 should equal 'zs'
      The line 4 should equal 'bs'
      The line 5 should equal 'za'
      The line 6 should equal 'ba'
      The line 7 should equal 'zb'
      The line 8 should equal 'bb'
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

  Describe 'run_command'
    It 'echos the command before evaluating it'
      When call run_command "echo 'hello'"
      The line 1 should equal "echo 'hello'"
      The line 2 should equal 'hello'
    End
  End
End
