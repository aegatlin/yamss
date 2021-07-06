nvim__prepare() { :; }

nvim__setup() { 
  ensure_command git
  ensure_command npm

  if ! [ -d "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs ]; then
    git clone --depth=1 https://github.com/savq/paq-nvim.git \
      "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
  fi

  # should come _after_ asdf__setup, which installs nodejs (ie, node, npm, etc.)
  # no harm in calling it even if it's already present
  npm install -g tree-sitter-cli
}

nvim__augment() { :; }

nvim__bootstrap() {
  # this will open nvim with empty file
  # run init.lua config, including paq.install() and lspinstall.install_server()
  # and then run :qall (aka :qa)
  # it's a 'hack' to install everything _before_ you open nvim for real.
  nvim +qall
}
