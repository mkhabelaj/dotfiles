return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			-- LSP servers
			"basedpyright", -- Python / Django
			"ruff", -- Python linter+formatter (also runs as LSP)
			"vtsls", -- TypeScript / React
			"cssls", -- CSS
			"html", -- HTML templates (Django templates too)
			"tailwindcss", -- if you use Tailwind
			"emmet_ls", -- HTML/JSX tag expansion
			"lua_ls",
			"jsonls",
			-- Linters (via mason + nvim-lint)
			-- "eslint_d", -- React/TS linting daemon
			-- Formatters (via mason + conform.nvim)
			-- "prettierd", -- JS/TS/JSX/TSX/CSS/HTML formatting daemon
			-- "black",
			-- "stylua",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
