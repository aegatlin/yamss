#! /bin/zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/bootstrap/create_bootstrap.sh)"
source ./bootstrap.sh
# PREAMBLE. PLEASE DO NOT REMOVE CODE ABOVE THIS COMMENT
########################################################

# For the moment, order matters
# so, e.g., put asdf at the end of the list
# since the augment shims need to come at
# the end of the .zshrc file
tools=(
  zsh # 1st, so it can throw if not present
  git # 2nd, since many things need it to exist
  brew # 3rd, bc it installs direnv and tmux(?)
  direnv
  asdf # last, bc it's augment shims needs to end the .zshrc file
)

load $tools