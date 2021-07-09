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
