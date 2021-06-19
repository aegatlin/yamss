##########
# zsh aliases
##########
alias g='git'
alias t='tmux'
alias v='vim'
alias ls='ls -G'
alias ll='ls -al'
alias ..='cd ..'
alias py='python3'
alias pr='pipenv run'
alias nr='npm run'
alias imps='iex -S mix phx.server'
alias mp='multipass'
alias update_nvim_nightly='asdf uninstall neovim nightly && asdf install neovim nightly'

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

##########
# brew setup
##########
if type brew &>/dev/null; then
  # for zsh completions, append brew completion functions location to FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

##########
# direnv setup
##########
eval "$(direnv hook zsh)"

##########
# asdf setup
##########
. $HOME/.asdf/asdf.sh
# for zsh completions, append asdf completion function locations to fpath
fpath=(${ASDF_DIR}/completions $fpath)

##########
# zsh completions
##########
# load and init zsh completions with compinit
autoload -Uz compinit
compinit

##########
# End of yams .zshrc edits
##########

export BAT_THEME="Solarized (light)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias luamake=/Users/austingatlin/lua-language-server/3rd/luamake/luamake
