nvim__prepare() { :; }

nvim__setup() { 
  git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

  npm install -g tree-sitter-cli
}

nvim__augment() { :; }
nvim__boostrap() { :; }
