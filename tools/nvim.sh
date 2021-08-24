nvim__prepare() {
  message 'nvim__prepare'
}

nvim__setup() {
  after asdf__setup # need nodejs for npm
  message 'nvim__setup'

  # nodejs required for nvim tree-sitter-cli install
  # ripgrep required for nvim telescope live_grep
  local tools=(neovim direnv ripgrep nodejs)
  for tool in "${tools[@]}"; do
    asdf_helper_plugin_add "$tool"
    asdf install "$tool" latest
    asdf global "$tool" "$(asdf latest "$tool")"
  done

  if ! [ -d "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs ]; then
    git clone --depth=1 https://github.com/savq/paq-nvim.git \
      "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
  fi

  npm install -g tree-sitter-cli
  asdf reshim # asdf won't detect the npm install while in a subshell
}

nvim__augment() {
  message 'nvim__augment'

  ensure_config_dir nvim
  config_put nvim/init.lua

  cat << 'DELIMIT' >> ~/.zshrc
##########
# direnv
##########
eval "$(direnv hook zsh)"

DELIMIT
}

nvim__bootstrap() {
  message 'nvim__bootstrap'

  nvim --headless +PaqInstall +qall
  nvim --headless +'TSInstallSync maintained' +qall
}
