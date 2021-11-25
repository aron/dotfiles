-- Utilities
local function augroup(name, autocmds)
    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        vim.cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    vim.cmd('augroup END')
end

-- Plugins

vim.call('plugpac#begin')

local packadd = vim.fn['plugpac#add']

-- VimScript Plugins
packadd('axelf4/vim-strip-trailing-whitespace')
packadd('editorconfig/editorconfig-vim')
packadd('junegunn/fzf', { ['dir'] = '~/.fzf', ['do'] = 'packadd fzf | call fzf#install()' })
packadd('junegunn/fzf.vim')
packadd('kergoth/vim-hilinks', {['on'] = 'HLT'})
packadd('solarnz/arcanist.vim')
packadd('tomtom/tcomment_vim')
packadd('tpope/vim-eunuch')     -- Unix file commands
packadd('tpope/vim-fugitive')   -- Git commands
packadd('tpope/vim-git')        -- Git syntax
packadd('tpope/vim-sleuth')     -- Detect indentation
packadd('tpope/vim-ragtag')     -- HTML tag mappings
packadd('tpope/vim-repeat')     -- Improved repeat to support surround.
packadd('tpope/vim-rsi')        -- Readline insertion
packadd('tpope/vim-surround')
packadd('tpope/vim-unimpaired') -- Keyboard navigation mappings
packadd('vim-scripts/ag.vim')   -- Better than grep
packadd('wellle/targets.vim')

-- Lua Plugins
packadd('neovim/nvim-lspconfig', { type = 'opt' })
packadd('nvim-treesitter/nvim-treesitter', {type = 'opt', ['do'] = ':TSUpdate'})
packadd('kdheepak/monochrome.nvim', { type = 'opt' })
packadd('williamboman/nvim-lsp-installer', { type = 'opt' })

vim.call('plugpac#end')

vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd nvim-treesitter')
vim.cmd('packadd monochrome.nvim')
vim.cmd('packadd nvim-lsp-installer')

-- Color Scheme
vim.cmd('silent! colorscheme monochrome')

-- Display
vim.opt.number = true
vim.opt.ruler = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 300

augroup('color_scheme', {
  { 'InsertEnter', '*', 'hi StatusLine cterm=bold ctermbg=None ctermfg=white' },
  { 'InsertLeave', '*', 'hi StatusLine cterm=bold ctermbg=None ctermfg=black' },
})

-- Display trailing and whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', eol = '¬' }

-- Columns
vim.opt.textwidth = 79
vim.opt.colorcolumn = { 120 }
vim.opt.formatoptions = 'cqj'
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.showmode = false

-- Disable swap files
vim.opt.dir = '~/.vim/swap'
vim.opt.swapfile = false
vim.opt.undodir = '~/.vim/undo'
vim.opt.undofile = true
vim.opt.hidden = true

-- Remap Leader
vim.g.mapleader = ' '

-- Allow backspacing over everything
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Whitespace
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
-- vim.opt.expandtab = true

-- Split Window
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.api.nvim_set_keymap('', '<leader>w', '<C-w>v<C-w><C-w>', {})

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<cr>', {})

augroup('plugins', {
    { 'InsertEnter', '*', 'setlocal', 'nohlsearch' },
    { 'InsertLeave', '*', 'setlocal', 'hlsearch' },
})

-- Expand %% to the current directory
vim.cmd("cabbr <expr> %% expand('%:p:h')")
vim.cmd("cabbr <expr> %f expand('%:t')")

-- Common Mappings
vim.api.nvim_set_keymap('', '<leader>cc', ':cclose <bar> lclose <cr>', {})

-- Stay in visual mode after indentation
vim.api.nvim_set_keymap('v', '<', '<gv', {})
vim.api.nvim_set_keymap('v', '>', '>gv', {})

-- Yank to System Clipboard
vim.api.nvim_set_keymap('', '<leader>y', '"*y', {})
vim.api.nvim_set_keymap('', '<leader>x', '"*x', {})
vim.api.nvim_set_keymap('', '<leader>d', '"*d', {})

-- Menu
vim.opt.completeopt = 'menu'
vim.opt.wildmode = { 'longest', 'list', 'full' }

-- Local .vimrc or .nvimrc
-- http://damien.lespiau.name/blog/2009/03/18/per-project-vimrc/
vim.opt.exrc = true   -- enable per-directory .vimrc files
vim.opt.secure = true -- disable unsafe commands in local .vimrc files

-- Netrw
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 30
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.g.netrw_list_hide = ''
vim.g.netrw_liststyle = 0

vim.cmd('filetype plugin indent on')

-- Git Commit Formatting
augroup('gitcommit', {
    { 'FileType', 'gitcommit', 'setlocal', 'spell textwidth=72 formatoptions=cqt nonumber noruler' },
})

-- Grep
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'

-- FZF
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<cr>', {})

-- TODO: Ensure Directory
local function ensure_dir(file, buf)
  if vim.fn.empty(vim.fn.getbufvar(file, '&buftype')) and not vim.regex('\\v^\\w+\\:\\/'):match_str(file) then
    local dir = vim.fn.fnamemodify(file, ':h')
    if not vim.fn.isdirectory(dir) then
      vim.fn.mkdir(dir, 'p')
    end
  end
end
_G.ensure_dir = ensure_dir

augroup('ensure_directory', {
  { 'BufWritePre', '*', ':lua ensure_dir(vim.fn.expand("<afile>"), vim.fn.expand("<abuf>"))' },
})

-- TreeSitter
require('nvim-treesitter.configs').setup({
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  vim.cmd('autocmd BufWritePre *.go lua lsp_imports_and_format(3000)')
  vim.cmd('autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 3000)')
  vim.cmd('autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 3000)')
end

-- https://github.com/williamboman/nvim-lsp-installer
local lsp_servers = { 'tsserver', 'efm', 'gopls', 'sumneko_lua', }
for _, name in pairs(lsp_servers) do
  local function on_server_ready(server)
    local opts = {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150, },
    }

    if server.name == "sumneko_lua" then
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
      opts.settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      }
    end

    if server.name == "tsserver" then
      opts.on_attach = function(client, bufno)
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufno)
      end
    end

    if server.name == "efm" then
      local cfg = {
        {
          formatCommand = "prettierd ${INPUT}",
          rootMarkers = {'package.json'},
          formatStdin = true,
        },
        {
          lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
          rootMarkers = {'package.json'},
          lintIgnoreExitCode = true,
          lintStdin = true,
          lintFormats = {'%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m'},
        },
      }
      opts.rootdir = vim.loop.cwd
      opts.filetypes = { 'typescript', 'javascript' }
      opts.init_options = { documentFormatting = true }
      opts.settings = {
        rootMarkers = { '.git' },
        languages = {
          typescript = cfg,
          javascript = cfg,
        },
      }
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end

  -- https://github.com/williamboman/nvim-lsp-installer/#setup
  local server_available, requested_server = require('nvim-lsp-installer').get_server(name)
  if server_available then
    requested_server:on_ready(on_server_ready)
    if not requested_server:is_installed() then
      requested_server:install()
    end
  end
end

-- LSP Formatting
local function lsp_imports(timeout_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

local function lsp_imports_and_format(timeout_ms)
  timeout_ms = timeout_ms or 1000
  lsp_imports(timeout_ms)
  vim.lsp.buf.formatting_sync(nil, timeout_ms)
end
_G.lsp_imports_and_format = lsp_imports_and_format

-- Go Linting
-- local lspconfig = require('lspconfig')
-- if not lspconfig.golangcilsp then
--   require('lspconfig/configs').golangcilsp = {
--     default_config = {
--       cmd = { 'golangci-lint-langserver' },
--       root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
--       init_options = {
--           command = { "golangci-lint", "run", "--out-format", "json" };
--       }
--     };
--   }
-- end
--
-- lspconfig.golangcilsp.setup({
--   filetypes = { "go" }
-- })

-- Print warnings
local required_tools = {
  ['prettierd'] = 'npm install -g @fsouza/prettierd',
  ['eslint_d'] = 'npm install -g eslint_d',
  ['golangci-lint-langserver'] = 'go get github.com/nametake/golangci-lint-langserver',
}
for tool, instruction in pairs(required_tools) do
  if vim.fn.executable(tool) ~= 1 then
    print(string.format('Missing executable "%s" install with: %s', tool, instruction))
  end
end

-- Statusline

-- to display a variable-length file path according
-- the width of the current window
local function file_path()
    local tail = vim.fn.expand('%:p:t')
    if tail == "" then
        return "[no name]"
    end
    if vim.opt.buftype:get() ~= "" then
        return tail
    end
    local head = vim.fn.substitute(vim.fn.expand('%:p:h'), vim.fn.expand('~'), '~', '') .. "/"
    local x = vim.fn.winwidth(vim.fn.winnr()) - 50
    local maxlen = vim.fn.float2nr(5 * vim.fn.sqrt(x < 0 and 0 or x))
    if vim.fn.strlen(head) > maxlen then
        head = vim.fn.strpart(head, vim.fn.strlen(head) - maxlen)
        head = vim.fn.strpart(head, vim.fn.match(head, '/') + 1)
    end
    return head .. tail
end

local function column_number()
  local vc = vim.fn.virtcol('.')
  local ruler_width = vim.fn.max({vim.fn.strlen(vim.fn.line('$')), (vim.opt.numberwidth:get() - 1)})
  local column_width = vim.fn.strlen(vc)
  local padding = ruler_width - column_width
  local column = ''

  if padding <= 0 then
    column = column .. vc
  else
    -- + 1 becuase for some reason vim
    -- eats one of the spaces
    column = column .. vim.fn['repeat'](' ', padding + 1) .. vc
  end

  return column
end

local function statusline ()
  local align_section = '%='
  local percentage_through_file = '%p%%'
  local filetype = vim.opt.filetype:get()
  if filetype == "" then
    filetype = "none"
  end

  return table.concat({
    column_number(),
    '%( %q%w%r%h%#StatusLineErr#%m%*%) ',
    file_path(),
    ' ',
    filetype,
    ' %( %r%m%w%)',
    align_section,
    ' ',
    percentage_through_file,
  })
end

vim.opt.laststatus = 2
_G.statusline = statusline
vim.cmd('set statusline=%!v:lua.statusline()')
