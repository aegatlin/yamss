#!/bin/zsh

apt__prepare () {
  __message "apt_prepare"
  __ensure_command apt
}

apt__setup () {
  apt install git
}