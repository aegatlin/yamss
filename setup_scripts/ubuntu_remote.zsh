#! /bin/zsh

########################################################
# PREAMBLE | DO NOT REMOVE
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/bootstrap/create_bootstrap.zsh)"
source ./bootstrap.zsh
# PREAMBLE | DO NOT REMOVE
########################################################

# For the moment, order matters
tools=(
  zsh
  apt
  snap
  tmux
  vim
)

load $tools
