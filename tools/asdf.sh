asdf__prepare() {
  ensure_command git

  if ! has_command asdf; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    pushd ~/.asdf || exit
    git checkout "$(git describe --abbrev=0 --tags)"
    popd || exit
  fi

  # Until '. $HOME/.asdf/asdf.sh' is written to ~/.zshrc,
  # source asdf.sh to have access to the asdf command
  source "$HOME"/.asdf/asdf.sh
}

asdf__setup() {
  ensure_command asdf

  plugin_add() {
    for tool in "$@"; do
      if ! asdf plugin list | grep -q "$tool"; then
        asdf plugin add "$tool"
      fi
    done
  }

  plugin_add_and_global_install_latest() {
    plugin_add "$@"
    for tool in "$@"; do
      asdf install "$tool" latest
      asdf global "$tool" "$(asdf latest "$tool")"
      asdf reshim "$tool" "$(asdf latest "$tool")"
    done
  }

  # java family: java, kotlin, gradle
  # erlang family: erlang, elixir
  plugin_add \
    elixir \
    elm \
    erlang \
    java \
    kotlin \
    gradle
    lua \
    postgres \
    python \
    shellspec \
    shellcheck \
    yarn
}

asdf__augment() {
  cat <<'DELIMIT' >>~/.zshrc
##########
# asdf
##########
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

DELIMIT
}

asdf__bootstrap() { :; }
