""""""""""""
" Table Of Contents
""""""""""""
" Ch 1: Initial Settings (~ line 10)
" Ch 2: Yamss Keybindings (~ line 20)
" Ch 3: vim-plug plugings (~ line 60)
" Ch 4: General Settings (~ line 80)
""""""""""""
""""""""""""
" Ch 1: Initial Settings
""""""""""""
""""""""""""

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader=','

""""""""""""
""""""""""""
" Ch 2: Yamss Keybindings
""""""""""""
"""""""""""

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
" Format
" nmap <Leader>f ???
""""""
" Other
""""""
" Explore Directory Toggle
nnoremap <Leader>e :NERDTreeToggle<CR>
" Reload Configuration
nnoremap  <Leader>r :source $MYVIMRC<CR>

""""""""""""
""""""""""""
" Ch 3: vim-plug Plugins
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

""""""""""""
""""""""""""
" Ch 4: General Settings
""""""""""""
""""""""""""

" Improved split behavior
set splitright
set splitbelow

" Base Vim settings
set number
set tabstop=2
set shiftwidth=2
set expandtab
set textwidth=80
set colorcolumn=+1 "" Colors the column 1 after textwidth
set noswapfile
