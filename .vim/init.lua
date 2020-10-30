local lsp = require('nvim_lsp')
local util = require('nvim_lsp/util')
local completion = require('completion')
local diagnostic = require('diagnostic')
local lsp_status = require('lsp-status')

-- https://github.com/neovim/nvim-lsp
local on_attach_vim = function(client)
  -- https://github.com/nvim-lua/completion-nvim
  completion.on_attach()
  -- https://github.com/nvim-lua/diagnostic-nvim
  diagnostic.on_attach()
  lsp_status.on_attach(client)
end

-- Ruby
lsp.solargraph.setup{ on_attach=on_attach_vim }

-- Lua
lsp.sumneko_lua.setup{
  on_attach=on_attach_vim,
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
}

-- JavaScript/TypeScript
lsp.tsserver.setup{
  on_attach=on_attach_vim,
  root_dir=util.root_pattern("package.json", "jsconfig.json", "tsconfig.json", ".git"),
  capabilities = lsp_status.capabilities
}

-- Vim
lsp.vimls.setup{ on_attach=on_attach_vim }

-- Golang
lsp.gopls.setup{
  on_attach=on_attach_vim,
  cmd = { "/Users/Aron/Code/go/bin/gopls" },
  root_dir = function (path)
    return util.root_pattern(".git", "go.mod")(path) or os.getenv("PWD")
  end
}

-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,                    -- false will disable the whole extension
      disable = { },                    -- list of language that will be disabled
      custom_captures = { },            -- mapping of user defined captures to highlight groups
    },
    incremental_selection = {
      enable = true,
      disable = { },
      keymaps = {                       -- mappings for incremental selection (visual mappings)
        init_selection = "gnn",         -- maps in normal mode to init the node/scope selection
        node_incremental = "grn",       -- increment to the upper named parent
        scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
        node_decremental = "grm",       -- decrement to the previous node
      }
    },
    refactor = {
      highlight_definitions = {
        enable = true
      },
      highlight_current_scope = {
        enable = false
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr"          -- mapping to rename reference under cursor
        }
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",      -- mapping to go to definition of symbol under cursor
          list_definitions = "gnD"      -- mapping to list all definitions in current file
        }
      }
    },
    textobjects = { -- syntax-aware textobjects
        enable = true,
        disable = {},
        keymaps = {
          ["iL"] = { -- you can define your own textobjects directly here
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function"
        },
        -- or you use the queries from supported languages with textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["ae"] = "@block.outer",
        ["ie"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["is"] = "@statement.inner",
        ["as"] = "@statement.outer",
        ["ad"] = "@comment.outer",
        ["am"] = "@call.outer",
        ["im"] = "@call.inner"
      }
    },
    ensure_installed = {"javascript", "typescript", "lua", "go"}
}

-- https://github.com/RishabhRD/nvim-lsputils
vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

