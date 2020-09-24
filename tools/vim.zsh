#!/bin/zsh

vim__prepare() {
  ensure_command vim
}

vim__setup() {}

vim__augment() {
  rm -f ~/.vimrc
  cat <<'DELIMIT' >~/.vimrc
""""""""""
" vim-plug settings
""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
call plug#end()

""""""""""
" personal settings
"""""""""
set number

DELIMIT
}

vim__bootstrap() {}
