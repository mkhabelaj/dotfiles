local caps = require("cmp_nvim_lsp").default_capabilities()
return {
	before_init = require("venv-selector").python,
	capabilities = caps,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "off",
				autoImportCompletions = true,
			},
		},
	},
}
