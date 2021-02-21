if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader=','

" Improved split behavior
set splitright
set splitbelow

""""""""""""
" yams keybindings
""""""""""""
" Canvas Split
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>h :split<CR>
" Canvas Navigate
nnoremap <Leader>l <C-w><Left>
nnoremap <Leader>r <C-w><Right>
nnoremap <Leader>u <C-w><Up>
nnoremap <Leader>d <C-w><Down>
" Canvas Move
nnoremap <Leader>L <C-w>r
nnoremap <Leader>R <C-w>R
nnoremap <Leader>U <C-w>R
nnoremap <Leader>D <C-w>r
" Canvas Close
nnoremap <Leader>w <C-w>q



call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
call plug#end()
