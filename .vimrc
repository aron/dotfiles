source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

set t_Co=256

syntax on

augroup color_scheme
  au!
  au VimEnter * colorscheme default | set background=dark | source ~/.vim/after/colors/default.vim

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

" set spell

" Mouse
set mouse=""

" No vi compatibility
set nocompatible
set nostartofline
set visualbell
set timeoutlen=500

" Columns
set textwidth=79
set colorcolumn=+1
set formatoptions=cq
try | set formatoptions+=j | catch | endtry

" Disable swap files
set noswapfile
set undodir=~/.vim/undo
set undofile

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

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn
set wildignore+=*.png,*.jpg,*.gif,*.woff,*.ttf,*.eot
set wildignore+=test/fixtures/*,vendor/gems/*,node_modules/*

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

let g:CommandTCancelMap=['<Esc>', '<C-c>']
let g:CommandTMatchWindowReverse=1

" gist-vim: https://github.com/mattn/gist-vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_private = 1

let g:syntastic_javascript_checker="jshint"
let g:syntastic_quiet_warnings=1
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [], 'passive_filetypes': ['html', 'scss'] }

augroup plugins
  autocmd!
  autocmd InsertEnter * :setlocal nohlsearch
  autocmd InsertLeave * :setlocal hlsearch
  autocmd FileType css,scss,less,html,xml setlocal iskeyword+=-
  autocmd FileType scss,javascript,coffee setlocal iskeyword+=$
  autocmd FileType gitcommit setlocal textwidth=72 formatoptions=cqt nonumber noruler
augroup END
