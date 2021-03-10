if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader=','

""""""""""""
" yams keybindings
""""""""""""
""""""
" Canvas
""""""
" Split
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>b :split<CR>
" Navigate
nnoremap <Leader>h <C-w><Left>
nnoremap <Leader>l <C-w><Right>
nnoremap <Leader>j <C-w><Up>
nnoremap <Leader>k <C-w><Down>
" Move
nnoremap <Leader>H <C-w>r
nnoremap <Leader>L <C-w>R
nnoremap <Leader>J <C-w>R
nnoremap <Leader>K <C-w>r
" Close
nnoremap <Leader>w <C-w>q
""""""
" Other
""""""
" Explore Directory Toggle
nnoremap <Leader>e :NERDTreeToggle<CR>
""""""""""""
""""""""""""

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'preservim/nerdtree'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-html'
Plug 'neoclide/coc-css'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-prettier', {'do': 'npm install'}
call plug#end()

" Improved split behavior
set splitright
set splitbelow

set number
