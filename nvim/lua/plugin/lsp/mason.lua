
local servers = {
	"lua_ls",
	"pyright",
	"jsonls",
	"pyright",
	"clangd",
	"marksman",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

-- Use the new vim.lsp.config API (Neovim 0.11+)
local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("plugin.lsp.handlers").on_attach,
		capabilities = require("plugin.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "plugin.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	-- Configure the LSP server using the new API
	vim.lsp.config[server] = {
		cmd = opts.cmd,
		filetypes = opts.filetypes,
		root_markers = opts.root_dir and { opts.root_dir } or { '.git' },
		settings = opts.settings,
		on_attach = opts.on_attach,
		capabilities = opts.capabilities,
	}

	-- Enable the LSP server
	vim.lsp.enable(server)
end
