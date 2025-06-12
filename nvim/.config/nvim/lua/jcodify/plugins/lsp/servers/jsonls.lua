local caps = require("cmp_nvim_lsp").default_capabilities()

local default_schemas = {}
pcall(function()
	default_schemas = require("nlspsettings.jsonls").get_default_schemas()
end)
local schemas = {
	{
		description = "tsconfig",
		fileMatch = { "tsconfig*.json" },
		url = "https://json.schemastore.org/tsconfig.json",
	},
	{
		description = "package.json",
		fileMatch = { "package.json" },
		url = "https://json.schemastore.org/package.json",
	},
	-- add more schemas here...
}
return {
	capabilities = caps,
	settings = { json = { schemas = vim.tbl_extend("keep", default_schemas or {}, schemas) } },
}
