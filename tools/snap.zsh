#!/bin/zsh

snap__prepare() {
  ensure_command snap
}

snap__setup() {
  snap install direnv
}

snap__augment() {}

snap__bootstrap() {}
