#! /bin/zsh

# apt is the old Ubuntu package manager.
# Try to use Snap for modern package management if possible.
# Some packages only exist on apt,
# and so you will need to continue using it.

apt__prepare() {
  ensure_command apt
}

apt__setup() {
  apt install curl
  apt install git
  apt install tmux
  apt install vim
  apt install net-tools
  apt install nmap
}

apt__augment() {}

apt__bootstrap() {}
