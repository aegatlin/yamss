#! /bin/zsh

apt__prepare() {
  ensure_command apt
}

apt__setup() {
  apt install git
  apt install net-tools
  apt install nmap
  apt install direnv
}

apt__augment() {}

apt__bootstrap() {}
