
local servers = {
	"lua_ls",
	"pyright",
	"jsonls",
	"clangd",
	"marksman",
}

local settings = {
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup(settings)
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

-- Get default capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Common on_attach function
local on_attach = function(client, bufnr)
	-- Use handlers.lua on_attach function
	require("plugin.lsp.handlers").on_attach(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

-- Load server-specific configurations
local server_configs = {}
for _, server in ipairs(servers) do
	local has_config, config = pcall(require, "plugin.lsp.settings." .. server)
	if has_config then
		server_configs[server] = config
	end
end

-- Setup each LSP server using the new vim.lsp.config API
for _, server_name in ipairs(servers) do
	-- Get server-specific settings if they exist
	local server_settings = {}
	if server_configs[server_name] and server_configs[server_name].settings then
		server_settings = server_configs[server_name].settings
	end

	-- Configure the LSP server
	vim.lsp.config(server_name, {
		capabilities = capabilities,
		settings = server_settings,
	})

	-- Enable the LSP server with on_attach
	vim.lsp.enable({server_name, bufnr = nil, on_attach = on_attach})
end
