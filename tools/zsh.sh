#!/bin/zsh

zsh__augment () {
  rm ~/.zshrc
  _zsh__write_universal_zshrc
}

zsh__initiate () {
  source ~/.zshrc
}

_zsh__write_universal_zshrc () {
cat << DELIMIT > ~/.zshrc
##########
# zsh aliases
##########
alias ls='ls -G'
alias ll='ls -al'
alias g='git'
alias ..='cd ..'
alias py='python3'
alias pr='pipenv run'
alias nr='npm run'
alias s='iex -S mix phx.server'

##########
# PROMPT setup
##########
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats "%b"
precmd() { 
  vcs_info 
}
setopt prompt_subst
export PROMPT=$'\n''%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f'$'\n''%F{cyan}%D %T%f '

DELIMIT
}
