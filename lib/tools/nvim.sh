nvim__prepare() { :; }

nvim__setup() { 
  ensure_command git
  ensure_command npm

  git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

  # should come _after_ asdf__setup, which installs nodejs (ie, node, npm, etc.)
  npm install -g tree-sitter-cli
}

nvim__augment() { :; }
nvim__bootstrap() { :; }
