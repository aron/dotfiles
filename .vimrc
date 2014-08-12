if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'cloudhead/shady.vim'
NeoBundle 'duwanis/tomdoc.vim'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'hynek/vim-python-pep8-indent'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kevinw/pyflakes-vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'nvie/vim-flake8'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-pathogen'
NeoBundle 'tpope/vim-ragtag'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'vim-scripts/ag.vim'
NeoBundleFetch 'shougo/neobundle.vim'

call neobundle#end()

NeoBundleCheck

set t_Co=256
set encoding=utf-8
set shellpipe=> " do not pipe commands such as Ack to stdout.

syntax on
silent! colorscheme shady

set background=dark
hi Normal ctermbg=NONE
hi SpellBad cterm=underline ctermfg=9
hi ColorColumn ctermbg=234 ctermfg=NONE
hi SignColumn ctermbg=NONE

augroup color_scheme
  au!

  " now set it up to change the status line based on mode
  au InsertEnter * hi StatusLine cterm=bold ctermbg=None ctermfg=white
  au InsertLeave * hi StatusLine cterm=bold ctermbg=None ctermfg=black
augroup END

augroup javascript
  au!
  autocmd FileType javascript abbr puts console.log
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

function! GitStatusLine()
  let ret = fugitive#statusline()
  let ret = substitute(ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', nr2char(0x2b60) .' \1', 'g')
  return ret
endfunction

hi clear User1 " Used in the status line.
hi gitcommitOverflow ctermfg=red
hi SpellBad cterm=reverse ctermfg=red ctermbg=NONE
" hi Comment ctermfg=8
" hi Search cterm=inverse ctermfg=11 ctermbg=NONE
" hi Todo ctermbg=NONE ctermfg=3

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
set statusline+=\ %{exists('g:loaded_fugitive')?GitStatusLine():''}
set statusline+=\ %{strlen(&ft)?&ft:'none'}
set statusline+=\ %(\ %r%m%w%)
set statusline+=%=
set statusline+=%{exists('g:syntastic_exists')?SyntasticStatuslineFlag():''}
set statusline+=%p%%

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
set colorcolumn=+1,120
set formatoptions=cq
try | set formatoptions+=j | catch | endtry
set scrolloff=15

" Disable swap files
set noswapfile
set undodir=~/.vim/undo
set undofile
set hidden

" Remap Leader
let mapleader = "\<Space>"


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
nmap <leader><space> :nohlsearch<cr>

" Commands

" Expand %% to the current directory
cabbr <expr> %% expand('%:p:h')
cabbr <expr> %f expand('%:t')

" Tab completion
set wildmode=longest,list,full
set wildignore+=*.o,*.pyc,*.egg,*.obj,.git,*.rbc,*.class,.svn,.gems,.bin
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
nmap <leader>gb :Gbrowse<cr>
nmap <leader>rr :call RunLastSpec()<cr>
nmap <leader>rt :call RunNearestSpec()<cr>
nmap <leader>rs :call RunCurrentSpecFile()<cr>
nnoremap [b :BB<cr>
nnoremap ]b :BF<cr>

" Load the plugin and indent settings for the detected filetype
filetype plugin indent on

" No nice way to check for vim-rspec.
if exists("g:rspec_command")
  nmap <leader>ss :call RunCurrentSpecFile()<cr>
  nmap <leader>sf :call RunNearestSpec()<cr>
  nmap <leader>sr :call RunLastSpec()<cr>
endif

let g:CommandTMaxHeight=15
let g:CommandTCancelMap=['<Esc>', '<C-c>']
let g:CommandTMatchWindowReverse=1

" gist-vim: https://github.com/mattn/gist-vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_private = 1

let g:syntastic_javascript_checkers=["jshint", 'jscs']
let g:syntastic_javascript_jshint_conf='~/.jshintrc'
let g:syntastic_enable_highlighting = 1
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
let NERDTreeIgnore = ['\.pyc$']

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

augroup plugins
  autocmd!
  autocmd InsertEnter * :setlocal nohlsearch
  autocmd InsertLeave * :setlocal hlsearch
  autocmd FileType css,scss,less,html,xml,eruby setlocal iskeyword+=-
  autocmd FileType scss,javascript,coffee setlocal iskeyword+=$
  autocmd FileType gitcommit setlocal textwidth=72 formatoptions=cqt nonumber noruler spell
augroup END

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

nmap <leader>b :CtrlPBuffer<cr>
nmap <leader>t :CtrlP<cr>
nmap <leader>T :CtrlP %%<cr>

hi CtrlPMatch ctermfg=9
hi CtrlPLinePre ctermfg=8

let g:ctrlp_mruf_relative = 1
let g:ctrlp_switch_buffer = 1
let g:ctrlp_reuse_window = 'netrw\|nerdtree'
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn|gems|bundle|sass-cache)|env|node_modules|tmp)|\.(pyc,png|jpg|jpeg|gif|woff|ttf|eot|sock)$'
let g:ctrlp_status_func = {
  \ 'main': 'CtrlP_Statusline_1',
  \ 'prog': 'CtrlP_Statusline_2',
  \ }

" CtrlP_Statusline_1 and CtrlP_Statusline_2 both must return a full statusline
" and are accessible globally.
" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
"            a:1    a:2      a:3       a:4  a:5   a:6  a:7
fu! CtrlP_Statusline_1(...)
  let dir = ' %=%#LineNr# '.getcwd().' %*'
  retu a:5.dir
endf

" Argument: len
"           a:1
fu! CtrlP_Statusline_2(...)
  let len = '%#Function# '.a:1.' %*'
  let dir = ' %=%#LineNr# '.getcwd().' %*'
  " Return the full statusline
  retu len.dir
endf
