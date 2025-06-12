local caps = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig.util")

return {
	{
		capabilities = caps,
		cmd = { "gopls", "-remote=auto" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = util.root_pattern("go.work", "go.mod", ".git"),
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = { unusedparams = true },
			},
		},
	},
}
