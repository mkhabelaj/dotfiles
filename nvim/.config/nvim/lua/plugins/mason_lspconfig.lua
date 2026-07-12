return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		automatic_enable = true,
		ensure_installed = {
			-- LSP servers
			"basedpyright", -- Python / Django
			"vtsls", -- TypeScript / React
			"cssls", -- CSS
			"html", -- HTML templates (Django templates too)
			"tailwindcss", -- if you use Tailwind
			"emmet_ls", -- HTML/JSX tag expansion
			"lua_ls",
			"jsonls",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
	},
}
