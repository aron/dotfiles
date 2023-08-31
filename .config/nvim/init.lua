-- Utilities
local function augroup(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do vim.cmd('autocmd ' .. table.concat(autocmd, ' ')) end
  vim.cmd('augroup END')
end

-- Plugins
xpcall(require('packages').bootstrap, function() require('paq').install() end)

-- Color Scheme
vim.cmd('silent! colorscheme monochrome')
vim.cmd('hi clear NonText | hi link NonText Comment')

-- Display
vim.opt.number = true
vim.opt.ruler = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 300
vim.opt.mouse = 'a'

augroup('color_scheme', {
  {'InsertEnter', '*', 'hi StatusLine cterm=bold ctermbg=None ctermfg=white'},
  {'InsertLeave', '*', 'hi StatusLine cterm=bold ctermbg=None ctermfg=black'},
})

-- Display trailing and whitespace characters
vim.opt.list = true
vim.opt.listchars = {tab = '▸ ', trail = '·', eol = '¬'}

-- Columns
vim.opt.textwidth = 79
vim.opt.colorcolumn = {120}
vim.opt.formatoptions = 'cqj'
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.showmode = false

-- Disable swap files
vim.opt.dir = vim.fn.expand('~/.vim/swap')
vim.opt.swapfile = false
vim.opt.undodir = vim.fn.expand('~/.vim/undo')
vim.opt.undofile = true
vim.opt.hidden = true

-- Remap Leader
vim.g.mapleader = ' '

-- Allow backspacing over everything
vim.opt.backspace = {'indent', 'eol', 'start'}

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

augroup('plugins', {{'InsertEnter', '*', 'setlocal', 'nohlsearch'}, {'InsertLeave', '*', 'setlocal', 'hlsearch'}})

-- Expand %% to the current directory
vim.cmd('cabbr <expr> %% expand(\'%:p:h\')')
vim.cmd('cabbr <expr> %f expand(\'%:t\')')

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
vim.opt.wildmode = {'longest', 'list', 'full'}

-- Local .vimrc or .nvimrc
-- http://damien.lespiau.name/blog/2009/03/18/per-project-vimrc/
vim.opt.exrc = true -- enable per-directory .vimrc files
vim.opt.secure = true -- disable unsafe commands in local .vimrc files

vim.cmd('filetype plugin indent on')

-- Git Commit Formatting
augroup('gitcommit', {{'FileType', 'gitcommit', 'setlocal', 'spell textwidth=72 formatoptions=cqt nonumber noruler'}})

-- Grep
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'

-- FZF
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<cr>', {})

-- Ensure Directory
local function ensure_dir(file, buf)
  if vim.fn.empty(vim.fn.getbufvar(buf, '&buftype')) and not vim.regex('\\v^\\w+\\:\\/'):match_str(file) then
    local dir = vim.fn.fnamemodify(file, ':h')
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
  end
end

_G.ensure_dir = ensure_dir

augroup('ensure_directory', {{'BufWritePre', '*', ':lua ensure_dir(vim.fn.expand("<afile>"), vim.fn.expand("<abuf>"))'}})

-- TreeSitter: https://github.com/nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },
  indent = {enable = true},
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- https://github.com/neovim/nvim-lspconfig
  local bufopts = {noremap = true, silent = true, buffer = bufnr}
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format {async = true} end, bufopts)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, bufopts)

  -- Setup format on save.
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd('autocmd BufWritePre <buffer> lua lsp_imports_and_format()')
  end

  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local options = {
        focusable = false,
        close_events = {"BufLeave", "CursorMoved", "InsertEnter", "FocusLost"},
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, options)
    end,
  })
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

vim.lsp.set_log_level(vim.lsp.log_levels.ERROR)

-- Go Linting
-- Needs to be called before other code requires lspconfig to avoid caching
require('lspconfig.configs').golangcilsp = {
  default_config = {
    cmd = {'golangci-lint-langserver'},
    root_dir = require('lspconfig').util.root_pattern('.git', 'go.mod'),
    init_options = {command = {'golangci-lint', 'run', '--out-format', 'json'}},
  },
}
require('lspconfig').golangcilsp.setup({filetypes = {'go'}})

-- https://github.com/hrsh7th/nvim-cmp/
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({ensure_installed = {'tsserver', 'efm', 'gopls', 'lua_ls'}})

-- https://github.com/williamboman/nvim-lsp-installer
local function on_server_ready(server_name)
  local opts = {on_attach = on_attach, capabilities = capabilities, flags = {debounce_text_changes = 150}}

  if server_name == 'lua_ls' then
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    opts.settings = {
      Lua = {
        runtime = {version = 'LuaJIT'},
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
          -- Disable "luaassert" message
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {enable = false},
      },
    }
  end

  if server_name == 'efm' then
    local typescript_conf = {
      {formatCommand = 'prettierd ${INPUT}', rootMarkers = {'package.json'}, formatStdin = true},
      {
        lintCommand = 'eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
        rootMarkers = {'package.json'},
        lintIgnoreExitCode = true,
        lintStdin = true,
        lintFormats = {'%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m'},
      },
    }
    local lua_conf = {{formatCommand = 'lua-format -i', formatStdin = true, rootMarkers = {'init.lua'}}}
    opts.root_dir = require('lspconfig/util').root_pattern('package.json', 'init.lua', '.git')
    opts.filetypes = {'typescript', 'javascript', 'lua'}
    opts.init_options = {documentFormatting = true}
    opts.single_file_support = true
    opts.settings = {
      rootMarkers = {'.git', 'init.lua'},
      languages = {lua = lua_conf, typescript = typescript_conf, javascript = typescript_conf},
    }
  end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  require('lspconfig')[server_name].setup(opts)
end

-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/mason-lspconfig.txt
require("mason-lspconfig").setup_handlers {
  on_server_ready, -- default handler

  ["tsserver"] = function()
    local opts = {on_attach = on_attach, capabilities = capabilities, flags = {debounce_text_changes = 150}}

    require('typescript').setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false, -- enable debug logging for commands
      go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
      },
      server = opts, -- pass options to lspconfig's setup method,
    })
  end,
}

local function has_tsclient(bufnr)
  for _, client in pairs(vim.lsp.get_active_clients({bufnr})) do if client.name == "tsserver" then return true; end end
  return false
end

-- LSP Formatting
local function lsp_imports()
  if has_tsclient(vim.api.nvim_get_current_buf()) then
    local function onerror() print("ERROR: Unable to run organizeImports or addMissingImports") end

    local actions = require("typescript").actions
    xpcall(actions.organizeImports, onerror, {sync = true})
    xpcall(actions.addMissingImports, onerror, {sync = true})
  end
end

local function lsp_imports_and_format(timeout_ms)
  timeout_ms = timeout_ms or 1000
  lsp_imports()
  vim.lsp.buf.format({async = false, timeout_ms = timeout_ms})
end

_G.lsp_imports_and_format = lsp_imports_and_format

-- Print warnings
local required_tools = {
  ['prettierd'] = 'npm install -g @fsouza/prettierd',
  ['eslint_d'] = 'npm install -g eslint_d',
  ['golangci-lint-langserver'] = 'go get github.com/nametake/golangci-lint-langserver',
  ['lua-format'] = 'luarocks install --server=https://luarocks.org/dev luaformatter',
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
  if tail == '' then return '[no name]' end
  if vim.opt.buftype:get() ~= '' then return tail end
  local head = vim.fn.substitute(vim.fn.expand('%:p:h'), vim.fn.expand('~'), '~', '') .. '/'
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

local function lspstatus()
  if #vim.lsp.buf_get_clients() == 0 then return '' end

  local total = 0
  local result = {}
  local s = vim.diagnostic.severity
  local levels = {E = s.ERROR, W = s.WARN, I = s.INFO, H = s.HINT}

  for k, level in pairs(levels) do
    local count = #vim.diagnostic.get(0, {severity = level})
    total = total + count
    table.insert(result, {k, count})
  end

  if total == 0 then return '[OK]' end

  result = vim.tbl_filter(function(value) return value[2] > 0 end, result)
  local keys = vim.tbl_map(function(value) return table.concat(value, ':') end, result)
  return '[' .. table.concat(keys, ', ') .. ']'
end

local function statusline()
  local align_section = '%='
  local percentage_through_file = '%p%%'
  local filetype = vim.opt.filetype:get()
  if filetype == '' then filetype = 'none' end

  return table.concat({
    column_number(),
    '%( %q%w%r%h%#StatusLineErr#%m%*%) ',
    file_path(),
    ' ',
    filetype,
    ' %( %r%m%w%)',
    align_section,
    ' ',
    lspstatus(),
    ' ',
    percentage_through_file,
  })
end

vim.opt.laststatus = 2
_G.statusline = statusline
vim.cmd('set statusline=%!v:lua.statusline()')

-- Completion

local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')

cmp.setup({
  experimental = {ghost_text = true},
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args) vim.fn['vsnip#anonymous'](args.body) end,
  },
  completion = {keyword_length = 1},
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping.confirm({select = true}),
  }),
  sources = cmp.config.sources({
    {
      name = 'nvim_lsp',
      max_item_count = 15,
      entry_filter = function(entry, _)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
      end,
    },
  }),
  sorting = {
    comparators = {
      function(...) return cmp_buffer:compare_locality(...) end,
      cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
      cmp.config.compare.offset,
    },

  },
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end
  end,
  view = {entries = "native"},
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', { sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }) })

require('nvim-lightbulb').setup({autocmd = {enabled = true}})

