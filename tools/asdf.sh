asdf__prepare() {
  message 'asdf__prepare'

  if ! [ -d ~/.asdf ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    pushd ~/.asdf || exit
    git checkout "$(git describe --abbrev=0 --tags)"
    popd || exit
  fi

  # Until '. $HOME/.asdf/asdf.sh' is written to ~/.zshrc,
  # source asdf.sh to have access to the asdf command
  add_source "$HOME"/.asdf/asdf.sh
}

asdf__setup() {
  message 'asdf__setup'

  plugin_add() {
    for tool in "$@"; do
      if ! asdf plugin list | grep -q "$tool"; then
        asdf plugin add "$tool"
      fi
    done
  }

  plugin_add erlang elixir
  plugin_add java kotlin gradle
  plugin_add shellspec shellcheck
  plugin_add elm lua postgres python yarn
}

asdf__augment() {
  message 'asdf__augment'

  cat <<'DELIMIT' >>~/.zshrc
##########
# asdf
##########
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

DELIMIT
}

asdf__bootstrap() {
  message 'asdf__bootstrap'
}

