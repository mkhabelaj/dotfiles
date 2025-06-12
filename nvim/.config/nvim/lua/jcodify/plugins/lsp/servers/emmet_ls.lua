local caps = require("cmp_nvim_lsp").default_capabilities()

return {
	capabilities = caps,
	filetypes = {
		"html",
		"typescriptreact",
		"javascriptreact",
		"solid",
		"css",
		"sass",
		"scss",
		"less",
		"php",
		"javascript",
	},
}
