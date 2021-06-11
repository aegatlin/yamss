vim.g.mapleader = ' ' 

vim.o.splitright = true
vim.o.splitbelow = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.bo.swapfile = false

vim.api.nvim_set_keymap('n', '<leader>ei', ':vsp $MYVIMRC<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>ri', ':luafile $MYVIMRC<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>cd', '<cmd>colorscheme seoul256<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>cl', '<cmd>colorscheme flattened_light<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>c1l', '<cmd>colorscheme flattened_light<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>c1d', '<cmd>colorscheme flattened_dark<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>c2l', '<cmd>colorscheme seoul256-light<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>c2d', '<cmd>colorscheme seoul256<cr>', {})

require 'paq-nvim' {
	'savq/paq-nvim';
	'nvim-treesitter/nvim-treesitter';
	'neovim/nvim-lspconfig';
	'junegunn/seoul256.vim';
	'romainl/flattened';
}

vim.cmd('colorscheme flattened_light')

require 'nvim-treesitter.configs'.setup {
	ensure_installed = 'maintained',
	highlight = {
		enabled = true
	},
	incremental_selection = {
		enabled = true
	},
	indent = {
		enabled = true
	}
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.definition()<cr>', {})
end

local nvim_lsp = require('lspconfig')
local lsp_servers = { 'tsserver', 'bashls' }
for _, lsp in ipairs(lsp_servers) do
	nvim_lsp[lsp].setup { on_attach = on_attach }
end
