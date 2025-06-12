local caps = require("cmp_nvim_lsp").default_capabilities()

return {
	capabilities = caps,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			completion = { callSnippet = "Replace" },
		},
	},
}
