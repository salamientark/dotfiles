local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug ("42Paris/42header") -- 42header

Plug ("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})	-- nvim-treesitter
Plug ("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
Plug ('numToStr/Comment.nvim') -- Fast comment
Plug ('akinsho/bufferline.nvim', { ['tag'] = '*' }) -- Bufferline
Plug ("folke/which-key.nvim") -- Which-key
Plug ('kevinhwang91/promise-async') -- nvim UFO dependencies
Plug ('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && npx --yes yarn install' })
Plug ('norcalli/nvim-colorizer.lua')
-- COPILOT
Plug ('zbirenbaum/copilot.lua') -- Copilot lua
Plug ('zbirenbaum/copilot-cmp') -- Copilot-cmp
Plug ('CopilotC-Nvim/CopilotChat.nvim', { ['branch']= 'main' }) -- Copilot chat

-- COLOR SCHEME 
Plug ('navarasu/onedark.nvim') -- OneDark

-- CODE COMPLETION 
Plug ('hrsh7th/nvim-cmp')			-- The completion Plugin
Plug ('hrsh7th/cmp-buffer')			-- buffer completion
Plug ('hrsh7th/cmp-path')			-- path completion
Plug ('hrsh7th/cmp-cmdline')		-- cmd_line completion
Plug ('saadparwaiz1/cmp_luasnip')	-- luasnip completion
Plug ('hrsh7th/cmp-nvim-lsp')		-- lsp completion

-- LSP
Plug ('neovim/nvim-lspconfig')		-- enable LSP
Plug ('williamboman/mason-lspconfig.nvim')
Plug ('williamboman/mason.nvim')	-- LSP installer
Plug ('jose-elias-alvarez/null-ls.nvim') -- LSP diagnostics and code actions

-- SNIPPET ENGINE
Plug ('L3MON4D3/LuaSnip', {['tag'] = 'v2.*', ['do'] = 'make install_jsregexp'})
Plug ('rafamadriz/friendly-snippets')	-- Add tons of snippets

-- Telescope
Plug ('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.8' })	-- Telescope

-- Nvim-tree
Plug ('nvim-tree/nvim-web-devicons') -- optional
Plug ('nvim-tree/nvim-tree.lua')	-- Nvim-tree explorer

vim.call('plug#end')

-- colorscheme
require "plugin.onedark"

-- LOAD USER CONFIGURATION
require "config.options"
require "config.colorscheme"
require "config.keymaps"

-- LOAD PLUGINS
require "plugin.treesitter"
require "plugin.telescope"
require "plugin.nvim-tree"
require "plugin.autopairs"
require "plugin.comment"
require "plugin.bufferline"
require "plugin.42Header"
require "plugin.copilot"
require "plugin.copilot-chat"
require "plugin.cmp"

-- LOAD LSP
require "plugin.lsp"

-- LOAD LANGUAGE SPECIFIC PLUGIN
require "plugin.markdown-preview"
