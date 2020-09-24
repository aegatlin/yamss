#!/bin/zsh

direnv__prepare() {
  ensure_command direnv
}

direnv__setup() {}

direnv__augment() {
  cat <<'DELIMIT' >>~/.zshrc
##########
# direnv setup
##########
eval "$(direnv hook zsh)"

DELIMIT
}

direnv__bootstrap() {}
