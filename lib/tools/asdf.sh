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
  run_command "source $HOME/.asdf/asdf.sh"
}

asdf__setup() {
  ensure_command asdf

  plugin_add() {
    for tool in "$@"; do
      if ! asdf plugin list | grep -q "$tool"; then
        run_command "asdf plugin add $tool"
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

  # neovim is an exception to the norm until it's v0.5
  asdf plugin add neovim
  asdf install neovim nightly
  asdf global neovim nightly

  plugin_add_and_global_install_latest \
    tmux \
    direnv \
    nodejs # required for nvim treesitter cli

  plugin_add \
    elixir \
    elm \
    erlang \
    kotlin \
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
# asdf setup
##########
# asdf itself helper functions and fpath completions
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
# direnv
eval "$(direnv hook zsh)"

DELIMIT
}

asdf__bootstrap() { :; }
