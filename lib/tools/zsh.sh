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
