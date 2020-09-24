#!/bin/zsh

tmux__prepare() {}

tmux__setup() {}

tmux__augment() {
  rm -f ~/.tmux.conf
  cat <<'DELIMIT' >~/.tmux.conf
# split panes using \ and -
bind '\' split-window -h
bind - split-window -v
unbind '"'
unbind %

# reload config file
bind r source-file ~/.tmux.conf

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on

DELIMIT
}

tmux__bootstrap() {}
