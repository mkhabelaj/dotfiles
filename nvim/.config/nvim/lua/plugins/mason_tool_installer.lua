return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			-- Linters (via mason + nvim-lint)
			"eslint_d", -- React/TS linting daemon
			-- Formatters (via mason + conform.nvim)
			"prettierd", -- JS/TS/JSX/TSX/CSS/HTML formatting daemon
			"black",
			"stylua",
			"stylelint",
			"cspell_ls",
			-- Go
			"gofumpt",
			"goimports",
		},
	},
	dependencies = {
		"mason-org/mason.nvim",
	},
}
