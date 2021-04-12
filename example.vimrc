""""""""""""
" Table Of Contents
""""""""""""
" Ch 1: Initial Settings (~ line 10)
" Ch 2: Pucks (~ line 50)
" Ch 3: vim-plug plugings (~ line 90)

""""""""""""
""""""""""""
" Ch 1: Initial Settings
""""""""""""
""""""""""""

" Automatically install vim-plug. Works with vim & nvim
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Map the leader key to ,
let mapleader=' '

" Don't maintain compatibility with Vi, which is outdated and causes problems
set nocompatible

" Improved split behavior
set splitright
set splitbelow

" Show line numbers
set number

" Sets how many spaces a <Tab> counts for
set tabstop=2
" Uses spaces when pressing <Tab>
set expandtab

" Set text width to 80 and color column 81
set textwidth=80
set colorcolumn=+1

" Don't create swapfiles
set noswapfile

""""""""""""
""""""""""""
" Ch 2: Pucks
""""""""""""
""""""""""""

""""""
" Canvas
""""""
" Split
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>b :split<CR>
" Navigate
""" to Visible Canvas in Current Group
nnoremap <Leader>h <C-w><Left>
nnoremap <Leader>l <C-w><Right>
nnoremap <Leader>j <C-w><Down>
nnoremap <Leader>k <C-w><Up>
""" to Tabbed Canvas in Current Group
nnoremap <Leader><Tab> :tabnext<CR>
" Move
""" to Another Group
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
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-html'
Plug 'neoclide/coc-css'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-prettier', {'do': 'npm install'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
call plug#end()

let NERDTreeShowHidden=1
nmap <Leader>p :GFiles<CR>
