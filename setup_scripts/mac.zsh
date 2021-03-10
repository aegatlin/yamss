#! /bin/zsh

########################################################
# PREAMBLE | DO NOT REMOVE
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/bootstrap/create_bootstrap.zsh)"
source ./bootstrap.zsh
# PREAMBLE | DO NOT REMOVE
########################################################

# For the moment, order matters
tools=(
  zsh # 1st, so it can throw if not present
  git # 2nd, since many things need it to exist
  brew # 3rd, bc it installs direnv
  direnv
  tmux
  vim
  asdf # last, bc it's `augment` shims need to be last in the .zshrc file
)

load $tools