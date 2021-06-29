-- Chapters
-----------
-- Packages: ~ 10
-- Settings: ~ 20
-- Mappings: ~ 40
-- Configuration: ~ 60

-- Packages

require 'paq-nvim' {
  'savq/paq-nvim',
  'nvim-treesitter/nvim-treesitter',
  'neovim/nvim-lspconfig',
  'junegunn/seoul256.vim',
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-telescope/telescope.nvim',
  'ishan9299/nvim-solarized-lua',
  'b3nj5m1n/kommentary',
  'kabouzeid/nvim-lspinstall',
  'hrsh7th/nvim-compe',
}

-- Settings

vim.g.mapleader = ' '
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.colorcolumn = '81'
vim.opt.signcolumn = 'number'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.completeopt = 'menuone,noselect'
vim.cmd('colorscheme seoul256')

-- Mappings
-- post-leader availabilities
-- ab d  ghi   mnop  stuv xyz
-- ABCDEFGHIJ LMNOPQ STUVWXYZ

local nmaps = {
  {'<leader>cd', '<cmd>colorscheme seoul256<cr>'},
  {'<leader>cl', '<cmd>colorscheme solarized<cr>'},
  {'<leader>cc', [[<cmd>lua require'telescope.builtin'.colorscheme()<cr>]]},
  {'<leader>ei', ':vsp $MYVIMRC<cr>'},
  {'<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]]},
  {'<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]]},
  {'<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]]},
  {'<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]]},
  {'<leader>fd', [[<cmd>lua require'telescope.builtin'.file_browser()<cr>]]},
  {'<leader>q', ':q<CR>'},
  {'<leader>ri', ':luafile $MYVIMRC<cr>'},
  {'<leader>we', '<C-w>='},
  {'<leader>wh', ':resize<cr> :resize -10<cr>'},
  {'<leader>wu', ':resize<cr>'},
  {'<leader>wv', ':vertical resize<cr> :vertical resize -40<cr>'},
}

local lsp_maps = {
  {'K', '<cmd>lua vim.lsp.buf.definition()<cr>'},
  {'<leader>R', '<cmd>lua vim.lsp.buf.rename()<cr>'},
  {'<leader>ld', '<cmd>lua vim.lsp.buf.definition()<cr>'},
  {'<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>'},
  {'<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<cr>'},
  {'<leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>'},
  {'<leader>lr', '<cmd>lua vim.lsp.buf.references()<cr>'},
  {'<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<cr>'},
  {'<leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>'},
  {'<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<cr>'},
}

vim.cmd[[
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]]

local ts_maps = {
  init_selection = '<leader>k',
  node_incremental = '<leader>k',
  scope_incremental = '<leader>K',
  node_decremental = '<leader>j',
}

-- Configuration

for _, map in ipairs(nmaps) do
  local lhs, rhs = unpack(map)
  vim.api.nvim_set_keymap('n', lhs, rhs, {})
end

local lsp_config = require('lspconfig')
local lsp_install = require('lspinstall')

local on_attach = function(_, bufnr)
  for _, map in ipairs(lsp_maps) do
    local lhs, rhs = unpack(map)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, {})
  end
end

local function setup_servers()
  lsp_install.setup()

  local servers = lsp_install.installed_servers()

  for _, server in pairs(servers) do
    local s = { on_attach = on_attach }

    if server == 'lua' then
      s.settings = {Lua = {diagnostics = {globals = 'vim'}}}
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

require 'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = ts_maps.init_selection,
      node_incremental = '<leader>k',
      scope_incremental = '<leader>l',
      node_decremental = '<leader>j'
    }
  },
  indent = { enable = true }
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
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
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

