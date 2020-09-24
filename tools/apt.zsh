#!/bin/zsh

apt__prepare() {
  ensure_command apt
}

apt__setup() {
  apt install curl
  apt install git
}

apt__augment() {}

apt__bootstrap() {}
