source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

set t_Co=256

syntax on
colorscheme hemisu

set background=dark
hi Normal ctermbg=NONE
hi ColorColumn ctermbg=238

augroup color_scheme
  au!

  " now set it up to change the status line based on mode
  au InsertEnter * hi StatusLine cterm=bold ctermbg=None ctermfg=white
  au InsertLeave * hi StatusLine cterm=bold ctermbg=None ctermfg=black
augroup END

function! GitStatusLine()
  let ret = fugitive#statusline()
  let ret = substitute(ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', nr2char(0x2b60) .' \1', 'g')
  return ret
endfunction

set laststatus=2
set statusline=%3n\ %1*%-25.80f%*
set statusline+=\ %{exists('g:loaded_fugitive')?GitStatusLine():''}
set statusline+=\ %{strlen(&ft)?&ft:'none'}
set statusline+=\ %(\ %r%m%w%)
set statusline+=%=
set statusline+=%{exists('g:syntastic_exists')?SyntasticStatuslineFlag():''}
set statusline+=\ %l
set statusline+=/
set statusline+=%L
set statusline+=\ %p%%

" Display
set number
set ruler

" Display trailing whitespace and tab characters.
set list listchars=tab:▸\ ,trail:·,eol:¬

" Shortcuts and fat fingers
cnoreabbrev W  w
cnoreabbrev T  tabedit
cnoreabbrev B  buffers
cnoreabbrev Q  q
cnoreabbrev W  w
cnoreabbrev Wq wq

" Remap keys for tmux
map <Esc>[A <Up>
map <Esc>[B <Down>
map <Esc>[C <Right>
map <Esc>[D <Left>

" Mouse
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" No vi compatibility
set nocompatible
set nostartofline
set visualbell
set timeoutlen=500
set autoread

" Columns
set textwidth=79
set colorcolumn=+1
set formatoptions=cq
try | set formatoptions+=j | catch | endtry
set scrolloff=3
set showcmd

" Disable swap files
set noswapfile
set undodir=~/.vim/undo
set undofile
set hidden

" Remap Leader
nnoremap " " <Nop>
let mapleader=" "

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Allow option enter to insert a newline.
inoremap <M-enter> <C-m><C-u>
imap <D-≥> <C-_>

nmap <leader>cc :cclose<cr>

" Split windows
set splitbelow
nnoremap <leader>w <C-w>v<C-w><C-w>

" Searching
nnoremap / /\V
vnoremap / /\V
set ignorecase
set smartcase
set gdefault
set incsearch
set hlsearch
nnoremap <leader><leader> :nohlsearch<cr>

" Navigation
set scrolloff=3

" Commands

" Expand %% to the current directory
cabbr <expr> %% expand('%:p:h')
cabbr <expr> %f expand('%:t')

" Tab completion
set wildmode=longest,list,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,.gems,.bin
set wildignore+=*.png,*.jpg,*.gif,*.woff,*.ttf,*.eot
set wildignore+=test/fixtures/*,vendor/gems/*,node_modules/**,log/**,tmp/**

" http://damien.lespiau.name/blog/2009/03/18/per-project-vimrc/
set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files

" Edit the vimrc file using \v.
nnoremap <leader>V :tabedit $MYVIMRC<CR>

" Trim trailing whitespace.
augroup strip_whitespace
  au!
  au BufWrite * :call <SID>StripTrailingWhitespaces()
augroup END

" Function that strips trailing whitespace.
" http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

let g:netrw_altv = 1
let g:netrw_winsize = 30
let g:netrw_browse_split = 0
let g:netrw_preview = 1
let g:netrw_list_hide = ''
let g:netrw_liststyle = 0

nmap <leader>a  :Ack
nmap <leader>as :AckFromSearch<cr>
nmap <leader>rc :Rcontroller
nmap <leader>rm :Rmodel
nmap <leader>rv :Rview
nmap <leader>gb :Gbrowse<cr>

" Load the plugin and indent settings for the detected filetype
filetype plugin indent on

" No nice way to check for vim-rspec.
if exists("g:rspec_command")
  nmap <leader>ss :call RunCurrentSpecFile()<cr>
  nmap <leader>sf :call RunNearestSpec()<cr>
  nmap <leader>sr :call RunLastSpec()<cr>
endif

nmap <leader>b :CommandTBuffer<cr>
nmap <leader>t :CommandT<cr>
nmap <leader>T :CommandTFlush<cr>
let g:CommandTMaxHeight=15
let g:CommandTCancelMap=['<Esc>', '<C-c>']
let g:CommandTMatchWindowReverse=1

" gist-vim: https://github.com/mattn/gist-vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_private = 1

let g:syntastic_javascript_checkers=["jshint"]
let g:syntastic_javascript_jshint_conf='~/.jshintrc'
let g:syntastic_enable_highlighting = 1
let g:syntastic_quiet_warnings = 0
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['javascript', 'ruby'], 'passive_filetypes': ['html', 'scss'] }

function! ImprovedNERDTreeToggle()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    :NERDTreeToggle
  else
    :NERDTreeFind
  endif
endfunction

nmap <leader>f :call ImprovedNERDTreeToggle()<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

augroup plugins
  autocmd!
  autocmd InsertEnter * :setlocal nohlsearch
  autocmd InsertLeave * :setlocal hlsearch
  autocmd FileType css,scss,less,html,xml,erb setlocal iskeyword+=-
  autocmd FileType scss,javascript,coffee setlocal iskeyword+=$
  autocmd FileType gitcommit setlocal textwidth=72 formatoptions=cqt nonumber noruler
augroup END
