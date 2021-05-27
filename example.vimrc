""""""""""""
" Table Of Contents
""""""""""""
" Ch 1: Initial Settings (~ line 10)
" Ch 2: Plugins and Extensions (~ line 80)
" Ch 3: Mappings (~ line 130)
" Ch 4: Coc Configuration (~ line 170)
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

" Map the leader key to space
let mapleader=' '

" Remove all autocommands from the 'default autocommand group'
" so that multipe sourcings of vimrc don't duplicate the autocommands
autocmd!

" Don't maintain compatibility with Vi, which is outdated and causes problems
set nocompatible

" Enable syntax highlighting
syntax on

" Enables filetype detection, loads ftplugin, and loads indent
" (Not necessary on nvim and may not be necessary on vim 8.2+)
" To see your file's type: `:set filetype?`
filetype plugin indent on

" Improved split behavior
set splitright splitbelow

" Show line numbers and relative numbers
set number relativenumber

" Sets how many spaces a <Tab> counts for, use spaces over <Tab>
set tabstop=2 expandtab

" Set text width to 80 and color column 81
set textwidth=80 colorcolumn=+1

" Don't create swapfiles
set noswapfile

" Set Wildmenu so you can see possible completions when pressing <Tab>
set wildmenu

" Always show the status-line (the line at the bottom that shows the full
" filename, etc.)
set laststatus=2

" Set mouse to perform all normal functionality
set mouse=a

" Use syntax highlighting items as the default fold method
set foldmethod=syntax foldlevelstart=1 nofoldenable

" Experiment with autoformatting text
" I will likely have to set this for _only_ markdown, etc.
" a: turn on autoformatting
" w: trailing whitespace indicates that the paragraph continues on the next
" line, otherwise, treat the paragraph as having ende
set formatoptions+=aw

" Spellcheck Markdown files and add spelling completions
autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us
set complete+=kspell

" Auto-save, auto-read updates that occur in a file outside vim
set autoread autowriteall
" Experiment with saving on leaving insert mode or changing text in normal mod
autocmd InsertLeave,TextChanged * update

" Sets the regexp engine to auto, which unbricks vim for Typescript
set re=0

""""""""""""
""""""""""""
" Ch 2: Plugins and Extensions
""""""""""""
""""""""""""

" Vim-plug
call plug#begin()
" Systemic plugins
Plug 'preservim/nerdtree'
Plug 'preservim/vim-pencil'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-test/vim-test'
" Markdown plugins
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" Colorschemes
Plug 'junegunn/seoul256.vim'
Plug 'romainl/flattened'
" CoC plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Vim-plug plugin settings

" vim-test
let test#strategy = "vimterminal"

" NERDTree
let NERDTreeShowHidden=1

" fzf
" This adds fzf completions to vim
set rtp+=/usr/local/opt/fzf

" CoC
let g:coc_global_extensions = ['coc-css', 'coc-elixir', 'coc-html', 'coc-json',
  \ 'coc-prettier', 'coc-snippets', 'coc-tsserver']

" Colorscheme
colorscheme seoul256

""""""""""""
""""""""""""
" Ch 3: Mappings
""""""""""""
""""""""""""
" Available first letters
" ab de  hijklm o     uvwxyz
" ABCDEFGHIJ LMNOPQRSTUVWXYZ

" Sizing
nnoremap <leader>x :resize<CR> :vertical resize<CR>
nnoremap <leader>c <C-w>=
" Explore Directory
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
" Search
nmap <leader>pbl :BLines<CR>
nmap <leader>pf :Files<CR>
nmap <leader>pg :GFiles<CR>
nmap <leader>ph :History<CR>
nmap <leader>pr :Rg<CR>
" Format
vmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Reload Configuration
nnoremap <leader>rl :source $MYVIMRC<CR>
" Edit particular files
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>et :vsplit ~/.tmux.conf<CR>
" Goyo toggle
nnoremap <leader>g :Goyo<CR>
" Exiting
nnoremap <leader>q :q<CR>
" Testing
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>tv :TestVisit<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Colorschemes
" d for dark, l for light, s for search
nmap <leader>sd :colorscheme seoul256<cr>
nmap <leader>sl :colorscheme flattened_light<cr>
nmap <leader>ss :Colors<cr>


""""""""""""
""""""""""""
" Ch 4: Coc Configuration
""""""""""""
""""""""""""

" Formatting selected code.
command! -nargs=0 Prettier :CocCommand prettier.formatFile

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Settings below are taken directly from: https://github.com/neoclide/coc.nvim

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> ,a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> ,e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> ,c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> ,o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> ,s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> ,j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> ,k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> ,p  :<C-u>CocListResume<CR>
