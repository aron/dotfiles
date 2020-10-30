call plugpac#begin()

Pack 'bluz71/vim-moonfly-colors'
Pack 'cakebaker/scss-syntax.vim', {'for': 'scss'}
Pack 'cloudhead/shady.vim'
Pack 'dense-analysis/ale'
Pack 'editorconfig/editorconfig-vim'
" Pack 'fatih/vim-go'
Pack 'hail2u/vim-css3-syntax', {'for': 'css,scss'}
Pack 'hynek/vim-python-pep8-indent', {'for': 'python'}
Pack 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Pack 'junegunn/fzf.vim'
Pack 'jxnblk/vim-mdx-js', {'for': 'mdx'}
Pack 'keith/swift.vim'
Pack 'kergoth/vim-hilinks', {'on': 'HLT'}
Pack 'leafgarland/typescript-vim', {'for': 'typescript'}
Pack 'othree/yajs.vim', {'for': 'javascript,typescript'}
Pack 'pangloss/vim-javascript', {'for': 'javascript,typescript'}
Pack 'scrooloose/nerdtree', {'on': 'ImprovedNERDTreeToggle'}
Pack 'solarnz/arcanist.vim'
Pack 'tomtom/tcomment_vim'
Pack 'tpope/vim-eunuch'   " Unix file commands
Pack 'tpope/vim-fugitive' " Git commands
Pack 'tpope/vim-git'      " Git syntax
Pack 'tpope/vim-ragtag'   " HTML tag mappings
Pack 'tpope/vim-repeat'   " Improved repeat to support surround.
Pack 'tpope/vim-rsi'      " Readline insertion
Pack 'tpope/vim-surround'
Pack 'tpope/vim-unimpaired' " Keyboard navigation mappings
Pack 'vim-scripts/ag.vim' " Better than grep
Pack 'wellle/targets.vim'

" Neovim Plugins
Pack 'nvim-treesitter/nvim-treesitter', {'type': 'opt'}
Pack 'RishabhRD/nvim-lsputils', { 'type': 'opt' }
Pack 'RishabhRD/popfix', { 'type': 'opt' }
Pack 'neovim/nvim-lsp', {'type': 'opt'}
Pack 'nvim-lua/completion-nvim', {'type': 'opt'}
Pack 'nvim-lua/diagnostic-nvim', {'type': 'opt'}
Pack 'nvim-lua/lsp-status.nvim', {'type': 'opt'}

call plugpac#end()

set t_Co=256
if &encoding != 'utf-8'
  set encoding=utf-8
endif
let g:polyglot_disabled = ['go.plugin']
syntax on

silent! colorscheme moonfly
" silent! colorscheme shady
" set background=dark
" hi Normal ctermbg=NONE
" hi NonText ctermfg=black
" hi SpecialKey ctermfg=black
" hi SpellBad cterm=underline ctermfg=9 ctermbg=NONE guifg=#df7588 gui=underline
" hi ColorColumn ctermbg=234 ctermfg=NONE guifg=#1c1c1c
" hi SignColumn ctermbg=NONE
" hi MatchParen cterm=reverse
" hi diffAdded cterm=bold ctermfg=2 guifg=#fe2a66
" hi clear User1 " Used in the status line.
" hi gitcommitOverflow ctermfg=red
"
" " Neovim Treesitter
" highlight TSAnnotation      ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSConstant        ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSConstBuiltin    ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSConstMacro      ctermfg=white         ctermbg=NONE       cterm=NONE
" " Constructors
" highlight TSConstructor     ctermfg=white         ctermbg=NONE       cterm=NONE
" " Errors
" highlight TSError           ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSFuncBuiltin     ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSFuncMacro       ctermfg=white         ctermbg=NONE       cterm=NONE
" " import
" highlight TSInclude         ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSKeywordOperator ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSParameter       ctermfg=white         ctermbg=NONE       cterm=NONE
" " String Interpolation
" highlight TSPunctSpecial    ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSTag             ctermfg=white         ctermbg=NONE       cterm=NONE
" highlight TSTagDelimiter    ctermfg=white         ctermbg=NONE       cterm=NONE
" " Console
" highlight TSVariableBuiltin ctermfg=white         ctermbg=NONE       cterm=NONE

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

function! LspStatus() abort
  if luaeval('vim.lsp and #vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! GitStatusLine()
  let ret = fugitive#statusline()
  let ret = substitute(ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', '↪︎' .' \1', 'g')
  return ret
endfunction

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
set statusline+=%{LspStatus()}
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
cnoreabbrev T  tabedit
cnoreabbrev B  buffers
cnoreabbrev Q  q
cnoreabbrev W  w
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

" Allow option enter to insert a newline.
inoremap <M-enter> <C-m><C-u>
imap <D-≥> <C-_>

map <leader>cc :cclose <bar> lclose <cr>

map <leader>y "*y
map <leader>x "*x
map <leader>d "*d

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

set completeopt=menu

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

nmap <leader>a  :Ag!
nmap <leader>as :AgFromSearch!<cr>
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

" gist-vim: https://github.com/mattn/gist-vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_private = 1

let g:markdown_fenced_languages = ['html', 'css', 'scss', 'javascript', 'typescript', 'python', 'bash=sh']

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

augroup plugins
  autocmd!
  autocmd InsertEnter * :setlocal nohlsearch
  autocmd InsertLeave * :setlocal hlsearch
  autocmd FileType css,scss,less,html,xml,eruby setlocal iskeyword+=-
  autocmd FileType scss,javascript setlocal iskeyword+=$
  autocmd FileType gitcommit setlocal textwidth=72 formatoptions=cqt nonumber noruler
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

if has('mouse_sgr')
  set ttymouse=sgr
endif

" https://github.com/ncm2/float-preview.nvim
let g:float_preview#docked=0

nmap <C-p> :Files<cr>

if !has('gui_macvim')
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let macvim_skip_colorscheme=1
else
  set guifont=SF\ Mono\ Regular:h14
endif

function! Wrap()
  setlocal wrap linebreak nolist showbreak=… columns=100
  noremap <buffer> <silent> k gk
  noremap <buffer> <silent> j gj
  noremap <buffer> <silent> <Up> gj
  noremap <buffer> <silent> <Down> gj
endfunction

command! -nargs=* Wrap call Wrap()

if has("nvim")
  packadd nvim-lsp
  packadd diagnostic-nvim
  packadd completion-nvim
  packadd nvim-treesitter
  packadd lsp-status.nvim
  packadd popfix
  packadd nvim-lsputils

  if exists(':luafile')
    packloadall
    luafile ~/.vim/init.lua
  endif

  set signcolumn=yes
  set updatetime=300

  let g:diagnostic_insert_delay = 1
  let g:diagnostic_enable_underline = 1
  let g:diagnostic_enable_virtual_text = 1
  let g:space_before_virtual_text = 5

  function! s:show_documentation()
    if &previewwindow " don't do this in the preview window
      return
    endif

    if luaeval("require('lsputils').has_diagnostics_at_cursor()")
      lua vim.lsp.util.show_line_diagnostics()
    else
      lua vim.lsp.buf.hover()
    endif
  endfunction

  nnoremap <silent> gD         <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gd         <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K          <cmd>call <SID>show_documentation()<CR>
  nnoremap <silent> gi         <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> <c-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> gy         <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> g0         <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gW         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
  nnoremap <silent> [c         <cmd>PrevDiagnosticCycle<CR>
  nnoremap <silent> ]c         <cmd>NextDiagnosticCycle<CR>
  nnoremap <silent> ge         <cmd>OpenDiagnostic<CR>
  nnoremap <silent> <leader>qf <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
  vnoremap <silent> <leader>f  <cmd>lua vim.lsp.buf.range_formatting()<CR>
  nnoremap <silent> <leader>f  <cmd>lua vim.lsp.buf.formatting()<CR>
  nnoremap <silent> <C-LeftMouse> <LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> <M-LeftMouse> <LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>

  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " map <c-p> to manually trigger completion
  inoremap <silent><expr> <c-space> completion#trigger_completion()

  let g:completion_matching_ignore_case = 1
  let g:completion_sorting = "none"

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c

  function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ completion#trigger_completion()

  augroup lsp_mappings
    autocmd!
    " Highlight symbol under cursor on CursorHold
    " autocmd CursorHold  <buffer> call <SID>show_documentation()
    " autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    " autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    " autocmd Filetype    javascript,typescript,typescriptreact,javascriptreact,lua,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
    " Disabled for the moment so it doesn't conflict with ALE
    " autocmd BufWritePre <buffer> lua pcall(vim.lsp.buf.formatting_sync, nil, 1000)
  augroup END
endif

let g:go_gopls_enabled = 0
let g:go_jump_to_error = 0
let g:go_def_mapping_enabled = 0

let g:moonflyUnderlineMatchParen = 1
let g:moonflyCursorColor = 1

let g:ale_linters_explicit = 1
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1
