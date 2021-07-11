-- Chapters
-----------
-- Packages: ~ 10
-- Settings: ~ 20
-- Mappings: ~ 70
-- Configuration: ~ 130
--   * LSP Config: ~ 230

-- Packages

local paq = require 'paq-nvim'

require 'paq-nvim' {
  'savq/paq-nvim',
  'nvim-lua/plenary.nvim', -- Utilities
  'nvim-lua/popup.nvim',
  'nvim-treesitter/nvim-treesitter', -- IDE Behavior
  'neovim/nvim-lspconfig',
  'kabouzeid/nvim-lspinstall',
  'hrsh7th/nvim-compe',
  'nvim-telescope/telescope.nvim',
  'vim-test/vim-test',
  'mhinz/vim-signify',
  'hoob3rt/lualine.nvim',
  'tpope/vim-surround', -- File Manipulation
  'ggandor/lightspeed.nvim',
  'b3nj5m1n/kommentary',
  'plasticboy/vim-markdown', -- Markdown Tooling
  'junegunn/goyo.vim',
  'overcache/NeoSolarized', -- Colors
}

paq.install()
paq.clean()

-- Settings

vim.g.mapleader = ' '
vim.opt.foldlevelstart = 3
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.colorcolumn = '81'
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.updatetime = 400
vim.o.completeopt = 'menuone,noselect'

vim.cmd 'autocmd!' -- Remove autocmds from top-level "default" autocmd group.
vim.cmd 'let g:goyo_width = 82'
vim.cmd[[
  set termguicolors
  silent! colorscheme NeoSolarized
  set background=light
]]
vim.cmd[[
  autocmd BufRead,BufNewFile mix.lock,*.ex,*.exs set filetype=elixir
  autocmd BufRead,BufNewFile *.eex,*.leex,*.sface set filetype=eelixir
]]
vim.cmd[[
  autocmd FileType markdown set formatoptions+=aw complete+=kspell
  autocmd FileType markdown setlocal spell spelllang=en_us
]]
-- Only update normal buffers (where buftype is empty).
-- Examples of non-updated buffer types: 'help', 'prompt'
vim.cmd[[ 
  set autoread autowriteall
  autocmd InsertLeave,TextChanged * if empty(&l:buftype) | update | endif 
]]
vim.cmd [[let test#strategy = 'neovim']]

-- Mappings
-- ab d   h jk mn p  s uv xyz
-- ABCDE  HIJ LMNOPQ S UVWXYZ

local nmaps = {
  {'<leader>cd', '<cmd>set background=dark<cr>'},
  {'<leader>cl', '<cmd>set background=light<cr>'},
  {'<leader>cc', [[<cmd>lua require'telescope.builtin'.colorscheme()<cr>]]},
  {'<leader>ei', ':vsp $MYVIMRC<cr>'},
  {'<leader>F', [[<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>]]},
  {'<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]]},
  {'<leader>fd', [[<cmd>lua require'telescope.builtin'.file_browser()<cr>]]},
  {'<leader>fF', [[<cmd>lua require'telescope.builtin'.git_files()<cr>]]},
  {'<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]]},
  {'<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]]},
  {'<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]]},
  {'<leader>fm', [[<cmd>lua require'telescope.builtin'.man_pages()<cr>]]},
  {'<leader>fo', [[<cmd>lua require'telescope.builtin'.oldfiles()<cr>]]},
  {'<leader>fr', [[<cmd>lua require'telescope.builtin'.lsp_references()<cr>]]},
  {'<leader>fld', [[<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>]]},
  {'<leader>fs', [[<cmd>lua require'telescope.builtin'.grep_string()<cr>]]},
  {'<leader>G', '<cmd>Goyo<cr>'},
  {'<leader>gd', '<cmd>:SignifyDiff<cr>'},
  {'<leader>gh', '<cmd>:SignifyHunkDiff<cr>'},
  {'<leader>gt', '<cmd>:SignifyToggle<cr>'},
  {'<leader>gu', '<cmd>:SignifyHunkUndo<cr>'},
  {'<leader>q', ':q<CR>'},
  {'<leader>ri', '<cmd>luafile $MYVIMRC<cr>'},
  {'<leader>s', '<cmd>w<cr>'},
  {'<leader>T', ':Telescope '},
  {'<leader>tf', '<cmd>TestFile<cr>'},
  {'<leader>tl', '<cmd>TestLast<cr>'},
  {'<leader>tn', '<cmd>TestNearest<cr>'},
  {'<leader>ts', '<cmd>TestSuite<cr>'},
  {'<leader>tv', '<cmd>TestVisit<cr>'},
  {'<leader>we', '<C-w>='},
  {'<leader>wh', ':resize<cr> :resize -10<cr>'},
  {'<leader>wu', ':resize<cr>'},
  {'<leader>wv', ':vertical resize<cr> :vertical resize -40<cr>'},
}

for _, map in ipairs(nmaps) do
  local lhs, rhs = table.unpack(map)
  vim.api.nvim_set_keymap('n', lhs, rhs, {})
end

-- there used to be values here and likely again will be
local imaps = { }

for _, map in ipairs(imaps) do
  local lhs, rhs = table.unpack(map)
  vim.api.nvim_set_keymap('i', lhs, rhs, {})
end

local lsp_maps = {
  {'<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<cr>'},
  {'<leader>ld', '<cmd>lua vim.lsp.buf.definition()<cr>'},
  {'<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>'},
  {'<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>'},
  {'<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<cr>'},
  {'<leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>'},
  {'<leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>'},
  {'<leader>ln', '<cmd>lua vim.lsp.buf.rename()<cr>'},
  {'<leader>lr', '<cmd>lua vim.lsp.buf.references()<cr>'},
  {'<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<cr>'},
}

vim.cmd[[
  inoremap <expr> <C-a> compe#complete()
  inoremap <expr> <C-s> compe#confirm('<cr>')
  inoremap <expr> <c-e> compe#close('<c-e>')
  inoremap <expr> <C-f> compe#scroll({ 'delta': +4 })
  inoremap <expr> <C-d> compe#scroll({ 'delta': -4 })
]]

local ts_maps = {
  init_selection = '<leader>o',
  node_incremental = '<leader>o',
  scope_incremental = '<leader>O',
  node_decremental = '<leader>i',
}

-- Configuration

require 'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = ts_maps.init_selection,
      node_incremental = ts_maps.node_incremental,
      scope_incremental = ts_maps.scope_incremental,
      node_decremental = ts_maps.node_decremental,
    }
  },
  indent = { enable = true }
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = true;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    spell = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = false;
  };
}

require 'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'solarized_light',
    section_separators = '',
    component_separators = { '|' }
  }
}

require 'telescope'.setup {
  defaults = {
    layout_strategy = 'flex',
    layout_config = {
      horizontal = {
        width = 0.9,
        preview_width = 0.6
      }
    }
  }
}

-- LSP configuration

local lsp_config = require('lspconfig')
local lsp_install = require('lspinstall')

local required_servers = {
  'bash', 'elixir',  'kotlin', 'lua', 'typescript', 'vim'
}
local installed_servers = lsp_install.installed_servers()

for _, server in pairs(required_servers) do
  if not vim.tbl_contains(installed_servers, server) then
    lsp_install.install_server(server)
  end
end

local on_attach = function(_, bufnr)
  for _, map in ipairs(lsp_maps) do
    local lhs, rhs = unpack(map)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, {})
  end
end

local function setup_servers()
  lsp_install.setup()

  for _, server in pairs(lsp_install.installed_servers()) do
    local s = { on_attach = on_attach }

    if server == 'lua' then
      s.settings = {Lua = {diagnostics = {globals = 'vim'}}}
    end

    if server == 'elixir' then
      local partial_path = '/lspinstall/elixir/elixir-ls/language_server.sh'
      s.cmd = { vim.fn.stdpath('data') .. partial_path }
    end

    lsp_config[server].setup(s)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>`
-- so we don't have to restart neovim
lsp_install.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
