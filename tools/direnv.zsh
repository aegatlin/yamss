#!/bin/zsh

direnv__prepare() {}

direnv__setup() {}

direnv__augment() {
  ensure_command direnv

  cat <<'DELIMIT' >>~/.zshrc
##########
# direnv setup
##########
eval "$(direnv hook zsh)"

DELIMIT
}

direnv__bootstrap() {}
