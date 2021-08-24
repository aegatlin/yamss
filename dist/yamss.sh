apt__prepare() {
  message 'apt__prepare'
}

apt__setup() {
  message 'apt__setup'

  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes

  # dependencies for java, kotlin, etc
  apt_helper_install jq unzip coreutils

  # dependencies for erlang, elixir, etc
  apt_helper_install libssl-dev libncurses5-dev unzip

  # dependencies for postgres
  apt_helper_install libreadline-dev build-essential zlib1g-dev

  # dependencies for python
  apt_helper_install make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils \
    tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  # command line tools I like
  apt_helper_install mosh net-tools nmap
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
  asdf_helper_plugin_add shellspec shellcheck shfmt
  asdf_helper_plugin_add elm lua postgres python yarn
}

asdf__augment() {
  message 'asdf__augment'

  cat << 'DELIMIT' >> ~/.zshrc
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

  brew_helper_install git

  # required to asdf install nodejs properly
  brew_helper_install gpg

  # casks/apps I use regularly
  brew_helper_install iterm2 firefox signal telegram slack bitwarden \
    visual-studio-code zoom discord

  # command line tools I like
  brew_helper_install mosh tree imagemagick
}

brew__augment() {
  message 'brew__augment'

  cat << 'DELIMIT' >> ~/.zshrc
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
git__prepare() {
  message 'git__prepare'
}

git__setup() {
  message 'git__setup'
}

git__augment() {
  message 'git__augment'

  ensure_config_dir git
  config_put git/config
}

git__bootstrap() {
  message 'git__bootstrap'
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
starship__prepare() {
  message 'startship__prepare'
}

starship__setup() {
  message 'startship__setup'
  after asdf__setup

  # only the "frontend" needs to have access to the appropriate fonts
  # for blink.sh on mobile devices, you do it through the UI
  # for iterm2 on mac, it is also through the UI, and is saved in config
  if is_mac; then
    brew tap homebrew/cask-fonts
    brew install font-fira-code-nerd-font
  fi

  asdf_helper_plugin_add starship
  asdf install starship latest
  asdf global starship "$(asdf latest starship)"
}

starship__augment() {
  message 'startship__augment'
  after zsh__augment

  cat << 'DELIMIT' >> ~/.zshrc
##########
# starship
##########
eval "$(starship init zsh)"

DELIMIT
}

starship__bootstrap() {
  message 'startship__bootstrap'
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

  ensure_config_dir tmux
  config_put tmux/tmux.conf
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
  cat << 'DELIMIT' > ~/.zshrc
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

# this is NOT the active prompt
# the active prompt uses starship
# this is the zsh-only fallback prompt
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

  cat << 'DELIMIT' >> ~/.zshrc
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
    if ((${#to_run[@]} > 0)); then
      ("${to_run[0]}")
      local r="$?"
      if [ "$r" = 0 ]; then
        ran+=("${to_run[0]}")
        run_sources
        if ((${#to_run[@]} > 1)); then
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
CONFIG_FOLDER="$HOME/.config"

# current setup assumptions:
#   - git is pre-installed
setup() {
  message 'yamss begin'
  if is_mac; then
    echo 'MacOS detected'
    load_tools git zsh brew asdf nvim tmux starship
  elif is_ubuntu; then
    echo 'Linux detected'
    load_tools git zsh apt asdf nvim tmux starship
  else
    message "OS detection failed: uname $(uname) not recognized"
    exit 1
  fi

  outro
}

outro() {
  message 'yamss end'
  message "(you should probably \`exit\` or \`reboot\` now)"
}

get_shell() {
  echo "$0"
}

is_mac() { [ "$(uname)" = 'Darwin' ]; }
is_ubuntu() { [ "$(uname)" = 'Linux' ]; }

ensure_config_dir() {
  ensure_dir "$CONFIG_FOLDER"
  ensure_dir "$CONFIG_FOLDER"/"$1"
}

config_put() {
  curl -fsSL "$CONFIG_URL"/"$1" > "$CONFIG_FOLDER/$1"
}

ensure_dir() {
  if ! [ -d "$1" ]; then mkdir "$1"; fi
}

message() {
  printf '* %s\n**********\n' "$1"
}

has_command() {
  command -v "$1" 1> /dev/null
}
setup

