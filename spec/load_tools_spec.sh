Describe 'load_tools'
  Include lib/load_tools.sh

  Describe 'load_tools'
    Context 'with no after relations'
      It 'calls tool functions in the appropriate order'
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

    Context 'with after relations in the same function phase'
      It 'calls the tool functions in order when the after relation function \
      should run last'
        zsh__prepare() { echo 'zp'; }
        zsh__setup() { echo 'zs'; }
        zsh__augment() { echo 'za'; }
        zsh__bootstrap() { after brew__bootstrap; echo 'zb'; }
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
        The line 7 should equal 'bb'
        The line 8 should equal 'zb'
      End

      xIt 'calls the tool functions in order when the after relation function \
      should run last in its phase group and is not the last phase group'
        zsh__prepare() { echo 'zp'; }
        zsh__setup() { echo 'zs'; }
        zsh__augment() { after brew__augment; echo 'za'; }
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
        The line 5 should equal 'ba'
        The line 6 should equal 'za'
        The line 7 should equal 'zb'
        The line 8 should equal 'bb'
      End
    End
  End

  Describe 'is_member'
    It 'returns 0 (success) if the element is a member of list'
      elem=a
      list=(a b c)
      When call is_member "$elem" "${list[@]}"
      The status should be success
    End

    It 'returns 1 (failure) if the element is not a member of list'
      elem=d
      list=(a b c)
      When call is_member "$elem" "${list[@]}"
      The status should be failure
    End
  End
End