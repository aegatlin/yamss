#!/bin/zsh

git__setup () {
  git config --global user.email 'austin@gatlin.io'
  git config --global user.name 'Austin Gatlin'
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.c commit
  git config --global alias.cane 'commit --amend --no-edit'
  git config --global alias.st status
  git config --global alias.lol 'log --oneline'
  git config --global alias.lolg 'log --oneline --graph'
}
