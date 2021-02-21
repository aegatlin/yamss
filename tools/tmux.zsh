#!/bin/zsh

tmux__prepare() {
  ensure_command tmux
}

tmux__setup() {}

tmux__augment() {
  rm -f ~/.tmux.conf
  curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/example.tmux.conf > ~/.tmux.conf
}

tmux__bootstrap() {}
