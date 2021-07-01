apt__prepare() {
  ensure_command apt
  apt update --assume-yes
  apt upgrade --assume-yes
}

apt__setup() {
  apt install --assume-yes make
  apt install --assume-yes automake
  apt install --assume-yes zip
  apt install --assume-yes net-tools
  apt install --assume-yes nmap
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

  # Until '. $HOME/.asdf/asdf.sh' is written to ~/.zshrc
  # source asdf.sh to access the asdf command
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
      asdf install "$tool" "$(asdf latest "$tool")"
      asdf global "$tool" "$(asdf latest "$tool")"
      asdf reshim "$tool"
    done
  }

  plugin_add_and_global_install_latest \
    tmux \
    neovim \
    direnv \

  plugin_add \
    elixir \
    elm \
    erlang \
    kotlin \
    lua \
    nodejs \
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
# asdf itself
. $HOME/.asdf/asdf.sh
# for zsh completions, append asdf completion function locations to fpath
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
zsh__prepare() {
  if ! has_command zsh; then
    if [ "$(uname)" = 'Linux' ]; then
      sudo apt install zsh
    else
      error_and_exit 'Unable to install zsh (probably on MacOS)'
    fi
  fi
}

zsh__setup() {
  if ! [[ "$SHELL" == "/bin/zsh" ]]; then
    echo "changing shell from $SHELL to /bin/zsh"
    chsh -s /bin/zsh
    echo "You will need to restart your terminal for shell changes to take effect"
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
    asdf install "$tool" $(asdf latest "$tool")
    asdf global "$tool" $(asdf latest "$tool")
    asdf reshim "$tool"
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

  printf "**********\nyamss setup completed\n**********\n"
  printf "Restart shell or 'source ~/.zshrc' to complete setup\n"
  if [ "$(uname)" = 'Darwin' ]; then
    printf "'source ~/.zshrc' has been copied to the paste buffer\n"
    printf 'source ~/.zshrc' | pbcopy
  fi
}

setup_mac() {
  load_tools zsh brew asdf
}

setup_linux() {
  load_tools zsh apt asdf
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
  for tool; do
    local tool_functions=(
      "${tool}__prepare"
      "${tool}__setup"
      "${tool}__augment"
      "${tool}__bootstrap"
    )
    for f in "${tool_functions[@]}"; do $f; done
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

setup

