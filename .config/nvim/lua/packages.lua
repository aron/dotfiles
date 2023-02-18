local install_path = vim.fn.stdpath('config') .. '/pack/packages/'

local all_plugins = {}

-- VimScript Plugins
local vim_plugins = {
  { 'axelf4/vim-strip-trailing-whitespace' },
  { 'cloudhead/shady.vim' },
  { 'editorconfig/editorconfig-vim' },
  { 'junegunn/fzf',                        run = function() vim.cmd('fzf#install()') end },
  { 'junegunn/fzf.vim' },
  { 'tomtom/tcomment_vim' },
  { 'tpope/vim-eunuch' }, -- Unix file commands
  { 'tpope/vim-fugitive' }, -- Git commands
  { 'tpope/vim-git' }, -- Git syntax
  { 'tpope/vim-ragtag' }, -- HTML tag mappings
  { 'tpope/vim-repeat' }, -- Improved repeat to support surround.
  { 'tpope/vim-rsi' }, -- Readline insertion
  { 'tpope/vim-rhubarb' }, -- Readline insertion
  { 'tpope/vim-sleuth' }, -- Detect indentation
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' }, -- Keyboard navigation mappings
  { 'tpope/vim-vinegar' }, -- Netrw
  { 'vim-scripts/ag.vim' }, -- Better than grep
}

-- Lua Plugins
local lua_plugins = {
  { 'savq/paq-nvim',                      opt = true },
  { 'hrsh7th/cmp-buffer',                 opt = true },
  { 'hrsh7th/cmp-cmdline',                opt = true },
  { 'hrsh7th/cmp-nvim-lsp',               opt = true },
  { 'hrsh7th/cmp-path',                   opt = true },
  { 'hrsh7th/cmp-vsnip',                  opt = true },
  { 'hrsh7th/nvim-cmp',                   opt = true },
  { 'hrsh7th/vim-vsnip',                  opt = true },
  { 'jose-elias-alvarez/typescript.nvim', opt = true },
  { 'kdheepak/monochrome.nvim',           opt = true },
  { 'kosayoda/nvim-lightbulb',            opt = true },
  { 'neovim/nvim-lspconfig',              opt = true },
  { 'nvim-treesitter/nvim-treesitter',    opt = true, run = function() vim.cmd('TSUpdate') end },
  { 'williamboman/mason.nvim',            opt = true },
  { 'williamboman/mason-lspconfig.nvim',  opt = true },
}

vim.list_extend(all_plugins, vim_plugins)
vim.list_extend(all_plugins, lua_plugins)

local is_headless = #vim.api.nvim_list_uis() == 0

local function clone_paq()
  local path = install_path .. 'opt/paq-nvim'

  if vim.fn.isdirectory(path) == 0 then
    vim.fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path })
    if is_headless and vim.v.shell_error > 0 then
      vim.api.nvim_err_writeln('clone of paq-nvim failed')
      vim.cmd('quit')
    end
  end
end

local function init_paq()
  clone_paq()

  -- Load Paq
  vim.cmd('packadd! paq-nvim')

  local paq = require('paq')

  -- Setup Custom Path
  paq:setup({ path = install_path })
  paq(all_plugins)

  if is_headless then
    -- Exit nvim after installing plugins
    vim.cmd('autocmd User PaqDoneInstall quit')
    paq.install()
  else
    for _, package in pairs(lua_plugins) do
      vim.cmd(string.format('packadd! %s', vim.fn.fnamemodify(package[1], ':t')))
    end
  end
end

return { bootstrap = init_paq }
