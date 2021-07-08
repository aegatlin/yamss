apt__prepare() {
  message 'apt__prepare'
}

apt__setup() {
  message 'apt__setup'

  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes

  apt_helper_install jq unzip coreutils # java & kotlin
  apt_helper_install libssl-dev libncurses5-dev unzip # erlang & elixir
  apt_helper_install libreadline-dev build-essential # postgres
  apt_helper_install net-tools nmap # cool tools I like
}

apt__augment() {
  message 'apt__augment'
}

apt__bootstrap() {
  message 'apt__bootstrap'
}

# Warning from apt itself:
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
apt_helper_install() {
  for package in "$@"; do
    if ! apt list --installed | grep -q "$package"; then
      sudo apt install --assume-yes "$package"
    fi
  done
}
asdf__prepare() {
  message 'asdf__prepare'

  if ! [ -d ~/.asdf ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    pushd ~/.asdf || exit
    git checkout "$(git describe --abbrev=0 --tags)"
    popd || exit
  fi

  # Until '. $HOME/.asdf/asdf.sh' is written to ~/.zshrc,
  # source asdf.sh to have access to the asdf command
  add_source "$HOME"/.asdf/asdf.sh
}

asdf__setup() {
  message 'asdf__setup'

  asdf_helper_plugin_add erlang elixir
  asdf_helper_plugin_add java kotlin gradle
  asdf_helper_plugin_add shellspec shellcheck
  asdf_helper_plugin_add elm lua postgres python yarn
}

asdf__augment() {
  message 'asdf__augment'

  cat <<'DELIMIT' >>~/.zshrc
##########
# asdf
##########
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

DELIMIT
}

asdf__bootstrap() {
  message 'asdf__bootstrap'
}

asdf_helper_plugin_add() {
  for tool in "$@"; do
    if ! asdf plugin list | grep -q "$tool"; then
      asdf plugin add "$tool"
    fi
  done
}
brew__prepare() {
  message 'brew__prepare'

  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

brew__setup() {
  message 'brew__setup'

  brew_helper_install git mosh gpg imagemagick
  brew_helper_install iterm2 firefox signal telegram slack bitwarden \
    visual-studio-code zoom
}

brew__augment() {
  message 'brew__augment'

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

brew__bootstrap() {
  message 'brew__bootstrap'
}

brew_helper_install() {
  for package in "$@"; do
    if ! brew list | grep -q "$package"; then
      brew install "$package"
    fi
  done
}
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
  message 'nvim__bootstrap'

  nvim --headless +PaqInstall +qall
  nvim --headless +'TSInstallSync maintained' +qall
}
tmux__prepare() {
  message 'tmux__prepare'
}

tmux__setup() {
  after asdf__setup
  if is_mac; then after brew__prepare; fi

  message 'tmux__setup'

  if is_mac; then
    brew_helper_install automake
  fi

  if is_ubuntu; then
    apt_helper_install ncurses-dev build-essential \
      bison pkg-config zip unzip automake
  fi

  asdf_helper_plugin_add tmux
  asdf install tmux latest
  asdf global tmux "$(asdf latest tmux)"
}

tmux__augment() {
  message 'tmux_augment'

  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/tmux"
  curl -fsSL "${CONFIG_URL}"/tmux/tmux.conf > "$HOME/.config/tmux/tmux.conf"
}

tmux__bootstrap() {
  message 'tmux__bootstrap'
}
zsh__prepare() {
  message 'zsh__prepare'

  if ! has_command zsh; then
    if is_ubuntu; then
      apt_helper_install zsh
    fi
  fi
}

zsh__setup() {
  message 'zsh__setup'

  if ! [[ "$SHELL" == "$(which zsh)" ]]; then
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

zsh__augment() {
  message 'zsh__augment'

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
  message 'zsh__bootstrap'

  cat <<'DELIMIT' >>~/.zshrc
##########
# zsh completions
##########
# load and init zsh completions with compinit
autoload -Uz compinit
compinit

DELIMIT
}
TOOL_SOURCES=()

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
        run_sources
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
          # run any sources the function added via add_source
          # try to empty the to_run list via try_to_empty_to_run_list
          ran+=("$f")
          run_sources
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

add_source() {
  TOOL_SOURCES+=("$1")
}

run_sources() {
  # shellcheck source=/dev/null
  for t in "${TOOL_SOURCES[@]}"; do
    source "$t"
  done

  TOOL_SOURCES=()
}
CONFIG_URL='https://raw.githubusercontent.com/aegatlin/setup/master/config'

setup() {
  message 'yamss setup initiated'
  if is_mac; then
    echo 'MacOS detected'
    load_tools zsh brew asdf nvim tmux
  elif is_ubuntu; then
    echo 'Linux detected'
    load_tools zsh apt asdf nvim tmux
  else
    message "OS detection failed: uname $(uname) not recognized"
    exit 1
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

message() {
  printf '**********\n%s\n**********\n' "$1"
}

has_command() {
  command -v "$1" 1>/dev/null
}
setup

