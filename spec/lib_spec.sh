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
        The line 3 should equal "restart shell ('exit') or reboot ('sudo reboot')"
      End

      It 'when shell is zsh, recommend restart or sourcing config with string place in the paste buffer'
        get_shell() { echo '-zsh'; }
        When call outro
        The line 3 should equal "restart shell ('exit') or 'source ~/.zshrc' (currently copied to paste buffer)"

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
        The line 3 should equal "restart shell ('exit') or reboot ('sudo reboot')"
      End

      It 'when shell is zsh, recommend restart or shourcing config'
        get_shell() { echo '-zsh'; }
        When call outro
        The line 3 should equal "restart shell ('exit') or 'source ~/.zshrc'"
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
End
