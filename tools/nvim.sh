nvim__prepare() {
  ensure_command git
  ensure_command npm
}

nvim__setup() {
  after asdf__setup # need nodejs for npm

  if ! [ -d "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs ]; then
    git clone --depth=1 https://github.com/savq/paq-nvim.git \
      "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
  fi

  npm install -g tree-sitter-cli
}

nvim__augment() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/nvim"
  local ROOT_PATH='https://raw.githubusercontent.com/aegatlin/setup/master/'
  curl -fsSL ${ROOT_PATH}lib/configs/init.lua > "$HOME/.config/nvim/init.lua"
}

nvim__bootstrap() {
  nvim +PaqInstall +qall
}
