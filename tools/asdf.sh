#!/bin/zsh

asdf__prepare () {
  if ! __has_command asdf; then
    __message "asdf__prepare"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    pushd ~/.asdf || exit
    git checkout "$(git describe --abbrev=0 --tags)"
    popd || exit
  fi
}

asdf__setup () {
  __message "asdf__setup"
  _asdf__ensure_plugin_add nodejs
  _asdf__ensure_plugin_add python
  _asdf__ensure_plugin_add postgres
  _asdf__ensure_plugin_add erlang
  _asdf__ensure_plugin_add elixir
}

_asdf__ensure_plugin_add () {
  if ! asdf plugin list | grep -q "$1"; then
    __run_command "asdf plugin add $1"
  fi
}

asdf__augment () {
  __message "asdf_augment"
  _asdf_append_to_zshrc
}

_asdf_append_to_zshrc() {
cat << DELIMIT >> ~/.zshrc
##########
# asdf setup
##########
. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

DELIMIT
}
