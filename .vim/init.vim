set packpath^=~/.config/nvim
set runtimepath^=~/.config/nvim

set t_Co=256
if &encoding != 'utf-8'
  set encoding=utf-8
endif
syntax on
colorscheme shady

augroup color_scheme
  au!

  " now set it up to change the status line based on mode
  au InsertEnter * hi StatusLine cterm=bold ctermbg=None ctermfg=white
  au InsertLeave * hi StatusLine cterm=bold ctermbg=None ctermfg=black
augroup END

" http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
function! s:EnsureDirectory(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

augroup ensure_directory
  au!
  au BufWritePre * :call s:EnsureDirectory(expand('<afile>'), +expand('<abuf>'))
augroup END

function! Column()
  let vc = virtcol('.')
  let ruler_width = max([strlen(line('$')), (&numberwidth - 1)])
  let column_width = strlen(vc)
  let padding = ruler_width - column_width
  let column = ''

  if padding <= 0
    let column .= vc
  else
    " + 1 becuase for some reason vim
    " eats one of the spaces
    let column .= repeat(' ', padding + 1) . vc
  endif

  return column
endfunction

set laststatus=2
set statusline=%{Column()}%(\ %q%w%r%h%#StatusLineErr#%m%*%)\ %{FilePath()}
set statusline+=\ %{strlen(&ft)?&ft:'none'}
set statusline+=\ %(\ %r%m%w%)
set statusline+=%=
set statusline+=\ %p%%

" to display a variable-length file path according the width of the
" current window
fu! FilePath()
    let tail = expand('%:p:t')
    if empty(tail)
        return "[no name]"
    endif
    if !empty(&bt)
        return tail
    endif
    let head = substitute(expand('%:p:h'), $HOME, '~', '') . "/"
    let x = winwidth(winnr()) - 50
    let maxlen = float2nr(5 * sqrt(x < 0 ? 0 : x))
    if strlen(head) > maxlen
        let head = strpart(head, strlen(head) - maxlen)
        let head = strpart(head, match(head, '/') + 1)
    endif
    return head . tail
endfu

" Display
set number
set ruler

" Display trailing whitespace and tab characters.
set list listchars=tab:▸\ ,trail:·,eol:¬

" Shortcuts and fat fingers
cnoreabbrev W  w
cnoreabbrev Q  q
cnoreabbrev Wq wq

" Mouse
set mouse=a

" No vi compatibility
set nocompatible
set nostartofline
set visualbell
set timeoutlen=500
set autoread
set history=1000

" Columns
set textwidth=79
set colorcolumn=+1,120
set formatoptions=cq
try | set formatoptions+=j | catch | endtry
set scrolloff=3
set sidescrolloff=5

" Disable swap files
set dir=~/.vim/swap
set noswapfile
set undodir=~/.vim/undo
set undofile
set hidden

" Remap Leader
let mapleader = "\<Space>"

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

map <leader>cc :cclose <bar> lclose <cr>

" Split windows
set splitbelow
map <leader>w <C-w>v<C-w><C-w>

" Searching
nnoremap / /\V
vnoremap / /\V
set ignorecase
set smartcase
set gdefault
set incsearch
set hlsearch
nmap <leader><space> :nohlsearch<cr>

" Commands

" Expand %% to the current directory
cabbr <expr> %% expand('%:p:h')
cabbr <expr> %f expand('%:t')

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

" Load the plugin and indent settings for the detected filetype
filetype plugin indent on

augroup plugins
  autocmd!
  autocmd InsertEnter * :setlocal nohlsearch
  autocmd InsertLeave * :setlocal hlsearch
  autocmd FileType gitcommit setlocal spell textwidth=72 formatoptions=cqt nonumber noruler
augroup END

if executable('rg')
  " Use rg over grep
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

if has('mouse_sgr')
  set ttymouse=sgr
endif

nmap <C-p> :Files<cr>
