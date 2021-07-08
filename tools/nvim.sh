nvim__prepare() {
  ensure_command git
}

nvim__setup() {
  after asdf__setup # need nodejs for npm

  # nodejs required for nvim tree-sitter-cli install
  # ripgrep required for nvim telescope live_grep
  local tools=(neovim direnv ripgrep nodejs)
  for tool in "${tools[@]}"; do
    asdf plugin add "$tool"
    asdf install "$tool" latest
    asdf global "$tool" "$(asdf "$tool" latest)"
  done

  if ! [ -d "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs ]; then
    git clone --depth=1 https://github.com/savq/paq-nvim.git \
      "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
  fi

  npm install -g tree-sitter-cli
}

nvim__augment() {
  ensure_dir "$HOME/.config/nvim"
  curl -fsSL "${CONFIG_URL}"/nvim/init.lua > "$HOME/.config/nvim/init.lua"

  cat <<'DELIMIT' >>~/.zshrc
##########
# direnv
##########
eval "$(direnv hook zsh)"

DELIMIT
}

nvim__bootstrap() {
  nvim +PaqInstall +qall
}
