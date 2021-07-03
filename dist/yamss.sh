apt__prepare() {
  ensure_command apt

  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes
}

apt__setup() {
  # redundant packages do no harm, and grouping them is useful
  local packages=()

  # tmux dependencies
  packages+=(
    libevent-dev ncurses-dev build-essential bison
    pkg-config zip unzip automake
  )

  # java/kotlin dependencies
  packages+=(jq unzip coreutils)

  # erlang/elixir dependencies
  packages+=(libssl-dev libncurses5-dev unzip)

  # postgres dependencies
  packages+=(libreadline-dev build-essential)

  # my packages
  packages+=(net-tools nmap)

  f() { sudo apt install --assume-yes "$1"; }
  for_each f "${packages[@]}"
}

apt__augment() { :; }

apt__bootstrap() { :; }
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

  # nodejs required for nvim treesitter cli
  plugin_add_and_global_install_latest \
    tmux \
    direnv \
    nodejs

  # kotlin depends on java, elixir depends on erlang
  plugin_add \
    elixir \
    elm \
    erlang \
    java \
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
brew__prepare() {
  ensure_command /bin/bash

  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

brew__setup() {
  ensure_command brew

  ensure_brew_install() {
    if ! brew list --formula | grep -q "$1"; then
      run_command "brew install $1"
    fi
  }

  ensure_brew_cask_install() {
    if ! brew list --cask | grep -q "$1"; then
      run_command "brew install --cask $1"
    fi
  }

  ensure_brew_install git
  ensure_brew_install mosh
  ensure_brew_install gpg
  ensure_brew_install imagemagick
  ensure_brew_cask_install visual-studio-code
  ensure_brew_cask_install iterm2
  ensure_brew_cask_install shiftit
  ensure_brew_cask_install karabiner-elements
  ensure_brew_cask_install firefox
  ensure_brew_cask_install signal
  ensure_brew_cask_install telegram
  ensure_brew_cask_install slack
  ensure_brew_cask_install bitwarden
}

brew__augment() {
  cat <<'DELIMIT' >>~/.zshrc
##########
# brew setup
##########
if type brew &>/dev/null; then
  # for zsh completions, append brew completion functions location to FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

DELIMIT
}

brew__bootstrap() { :; }
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
zsh__prepare() {
  if ! has_command zsh; then
    if [ "$(uname)" = 'Linux' ]; then
      sudo apt install --assume-yes zsh
    else
      error_and_exit 'Unable to install zsh (probably on MacOS)'
    fi
  fi
}

zsh__setup() {
  if ! [[ "$SHELL" == "$(which zsh)" ]]; then
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

zsh__augment() {
  rm -f ~/.zshrc
  cat <<'DELIMIT' >~/.zshrc
##########
# zsh aliases
##########
alias g='git'
alias t='tmux'
alias v='nvim'
alias ls='ls -G'
alias ll='ls -al'
alias ..='cd ..'
alias py='python3'
alias pr='pipenv run'
alias nr='npm run'
alias imps='iex -S mix phx.server'
alias asdf_update_nvim='asdf uninstall neovim nightly && asdf install neovim nightly'
asdf_global_latest() {
  for tool in "$@"; do
    asdf install "$tool" latest
    asdf global "$tool" $(asdf latest "$tool")
    asdf reshim "$tool" $(asdf latest "$tool")
  done
}

##########
# PROMPT setup
##########
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats "%b"
precmd() {
  vcs_info
}
setopt prompt_subst
export PROMPT=$'\n''%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f'$'\n''%F{cyan}%n@%M%f '

DELIMIT
}

zsh__bootstrap() {
  cat <<'DELIMIT' >>~/.zshrc
##########
# zsh completions
##########
# load and init zsh completions with compinit
autoload -Uz compinit
compinit

DELIMIT
}
setup() {
  printf "**********\nyamss setup initiated\n**********\n"
  if [ "$(uname)" = 'Darwin' ]; then
    echo 'MacOS detected'
    setup_mac
  elif [ "$(uname)" = 'Linux' ]; then
    echo 'Linux detected'
    setup_linux
  else
    error_and_exit "OS detection failed: uname $(uname) not recognized"
  fi

  write_configs
  outro
}

outro() {
  printf "**********\nyamss setup complete\n"
  if [ "$(get_shell)" = '-zsh' ]; then
    if [ "$(uname)" = 'Darwin' ]; then
      echo "restart shell ('exit') or 'source ~/.zshrc' (currently copied to paste buffer)"
      printf 'source ~/.zshrc' | pbcopy
    else
      echo "restart shell ('exit') or 'source ~/.zshrc'"
    fi
  else
    echo "restart shell ('exit') or reboot ('sudo reboot')"
  fi
  echo '**********'
}

get_shell() {
  echo "$0"
}

setup_mac() {
  load_tools zsh brew asdf nvim
}

setup_linux() {
  load_tools zsh apt asdf nvim
}

write_configs() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/nvim"
  ensure_dir "$HOME/.config/git"
  ensure_dir "$HOME/.config/tmux"

  local ROOT_PATH='https://raw.githubusercontent.com/aegatlin/setup/master/'
  curl -fsSL ${ROOT_PATH}lib/configs/init.lua > "$HOME/.config/nvim/init.lua"
  curl -fsSL ${ROOT_PATH}lib/configs/git.config > "$HOME/.config/git/config"
  curl -fsSL ${ROOT_PATH}lib/configs/tmux.conf > "$HOME/.config/tmux/tmux.conf"
}

ensure_dir() {
  if ! [ -d "$1" ]; then mkdir "$1"; fi
}

load_tools() {
  local postscripts=('__prepare' '__setup' '__augment' '__bootstrap')
  for p in "${postscripts[@]}"; do
    for tool; do
      "$tool$p"
    done
  done
}

has_command() {
  command -v "$1" 1>/dev/null
}

ensure_command() {
  if ! has_command "$1"; then
    error_and_exit "Command not found: $1"
  fi
}

run_command() {
  echo "$1"
  eval "$1"
}

error_and_exit() {
  echo "**********"
  echo "yamss error message: $1"
  echo "exiting"
  echo "**********"
  exit 1
}

for_each() {
  local f="$1"
  shift
  local ary=("$@")
  for e in "${ary[@]}"; do
    "$f" "$e"
  done
}
setup

