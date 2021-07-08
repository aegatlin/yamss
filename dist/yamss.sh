apt__prepare() {
  ensure_command apt
}

apt__setup() {
  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes
  # redundant packages do no harm, and grouping them is useful
  local packages=()

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
      brew install "$1"
    fi
  }

  ensure_brew_cask_install() {
    if ! brew list --cask | grep -q "$1"; then
      brew install --cask "$1"
    fi
  }

  ensure_brew_install git
  ensure_brew_install mosh
  ensure_brew_install gpg
  ensure_brew_install imagemagick
  ensure_brew_cask_install visual-studio-code
  ensure_brew_cask_install iterm2
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
tmux__prepare() { :; }

tmux__setup() {
  after asdf__setup

  if is_mac; then
    after brew__setup
    brew install automake
  fi

  if is_ubuntu; then
    after apt__setup
    sudo apt install --assume--yes libevent-dev ncurses-dev build-essential \
      bison pkg-config zip unzip automake
  fi

  asdf plugin add tmux
  asdf install tmux latest
  asdf global tmux "$(asdf latest tmux)"
}

tmux__augment() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/tmux"
  curl -fsSL "${CONFIG_URL}"/tmux/tmux.conf > "$HOME/.config/tmux/tmux.conf"
}

tmux__bootstrap() { :; }
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
load_tools() {
  after() {
    if ! is_member "$1" "${ran[@]}"; then
      exit 1
    fi
    return 0
  }

  try_to_empty_to_run_list() {
    if (( ${#to_run[@]} > 0 )); then
      ("${to_run[0]}")
      local r="$?"
      if [ "$r" = 0 ]; then
        ran+=("${to_run[0]}")
        if (( ${#to_run[@]} > 1 )); then
          to_run=("${to_run[@]:1}")
          try_to_empty_to_run_list
        else
          to_run=()
        fi
      fi
    fi
  }

  local ran=()
  local to_run=()
  local phases=('__prepare' '__setup' '__augment' '__bootstrap')
  for i in "${!phases[@]}"; do
    local phase="${phases[$i]}"

    local previous_phases=()
    if (("$i" > 0)); then
      previous_phases=("${phases[@]:0:i}")
    fi

    for tool; do
      # collect previous tool phases
      local previous_tool_phases=()
      for pp in "${previous_phases[@]}"; do
        previous_tool_phases+=("$tool$pp")
      done

      # if any previous tool phases are in to_run
      # also add this tool phase to to_run and skip
      local skip=false
      for ptp in "${previous_tool_phases[@]}"; do
        if [[ "${to_run[*]}" =~ $ptp ]]; then
          skip=true
        fi
      done

      local f="$tool$phase"

      if "$skip"; then
        to_run+=("$f")
      else
        # if no skip, actually run the function to see
        # if the internal after clause exits
        ("$f")
        local r="$?"
        if [ "$r" = 0 ]; then
          # if the function ran successfully
          # try to empty the to_run list
          ran+=("$f")
          try_to_empty_to_run_list
        else
          # if the function exited in the subshell
          # the after clause disallowed running
          # so add to the to_run list for later
          to_run+=("$f")
        fi
      fi
    done
  done
}

is_member() {
  local elem="$1"
  shift
  local list=("$@")
  [[ "${list[*]}" =~ $elem ]]
}

is_list_empty() {
  return "$#"
}
CONFIG_URL='https://raw.githubusercontent.com/aegatlin/setup/master/config'

setup() {
  printf "**********\nyamss setup initiated\n**********\n"
  if is_mac; then
    echo 'MacOS detected'
    load_tools zsh brew asdf nvim tmux
  elif is_ubuntu; then
    echo 'Linux detected'
    load_tools zsh apt asdf nvim tmux
  else
    error_and_exit "OS detection failed: uname $(uname) not recognized"
  fi

  write_configs
  outro
}

outro() {
  printf "**********\nyamss setup complete\n"
  if [ "$(get_shell)" = '-zsh' ]; then
    if is_mac; then
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

is_mac() { [ "$(uname)" = 'Darwin' ]; }
is_ubuntu() { [ "$(uname)" = 'Linux' ]; }

write_configs() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/git"
  curl -fsSL ${CONFIG_URL}/git/git.config > "$HOME/.config/git/config"
}

ensure_dir() {
  if ! [ -d "$1" ]; then mkdir "$1"; fi
}

has_command() {
  command -v "$1" 1>/dev/null
}

ensure_command() {
  if ! has_command "$1"; then
    error_and_exit "Command not found: $1"
  fi
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

