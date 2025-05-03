return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")
		local util = require("lspconfig.util")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local wk = require("which-key")
				wk.add({
					{ "<leader>l", buffer = ev.buf, group = "LSP" },
					{ "<leader>lR", ":LspRestart<CR>", buffer = ev.buf, desc = "Restart LSP" },
					{ "<leader>ld", buffer = ev.buf, group = "Diagnostics" },
					{ "<leader>ldj", vim.diagnostic.goto_next, buffer = ev.buf, desc = "Go to next diagnostic" },
					{ "<leader>ldk", vim.diagnostic.goto_prev, buffer = ev.buf, desc = "Go to previous diagnostic" },
					{ "<leader>ldl", vim.diagnostic.open_float, buffer = ev.buf, desc = "Show line diagnostics" },
					{ "<leader>ll", vim.diagnostic.open_float, buffer = ev.buf, desc = "Show line diagnostics" },
					{ "<leader>lo", "<cmd>Lspsaga outline<CR>", buffer = ev.buf, desc = "Show outline" },
					{ "<leader>lr", vim.lsp.buf.rename, buffer = ev.buf, desc = "Rename" },
					{
						mode = { "n", "v" },
						{ "<leader>la", vim.lsp.buf.code_action, buffer = ev.buf, desc = "Code action" },
					},
				})

				wk.add({
					{ "gl", "<cmd>Lspsaga peek_definition<CR>", buffer = ev.buf, desc = "Peek definition" },
					{ "gF", "<cmd>Lspsaga finder<CR>", buffer = ev.buf, desc = "Show LSP references" },
					{ "K", vim.lsp.buf.hover, buffer = ev.buf, desc = "Show documentation for what is under cursor" },
				})
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["gopls"] = function()
				lspconfig["gopls"].setup({
					capabilities = capabilities,
					cmd = { "gopls", "-remote=auto" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work", "go.mod", ".git"),
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
							},
						},
					},
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
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
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["pyright"] = function()
				-- configure pyright server
				lspconfig["pyright"].setup({
					before_init = require("venv-selector").python, -- use venv-selector
					capabilities = capabilities,
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
				})
			end,
			["intelephense"] = function()
				lspconfig["intelephense"].setup({
					capabilities = capabilities,
					settings = {
						intelephense = {
							stubs = {
								"apache",
								"bcmath",
								"bz2",
								"calendar",
								"com_dotnet",
								"Core",
								"ctype",
								"curl",
								"date",
								"dba",
								"dom",
								"enchant",
								"exif",
								"FFI",
								"fileinfo",
								"filter",
								"fpm",
								"ftp",
								"gd",
								"gettext",
								"gmp",
								"hash",
								"iconv",
								"imap",
								"intl",
								"json",
								"ldap",
								"libxml",
								"mbstring",
								"meta",
								"mysqli",
								"oci8",
								"odbc",
								"openssl",
								"pcntl",
								"pcre",
								"PDO",
								"pdo_ibm",
								"pdo_mysql",
								"pdo_pgsql",
								"pdo_sqlite",
								"pgsql",
								"Phar",
								"posix",
								"pspell",
								"readline",
								"Reflection",
								"session",
								"shmop",
								"SimpleXML",
								"snmp",
								"soap",
								"sockets",
								"sodium",
								"SPL",
								"sqlite3",
								"standard",
								"superglobals",
								"sysvmsg",
								"sysvsem",
								"sysvshm",
								"tidy",
								"tokenizer",
								"xml",
								"xmlreader",
								"xmlrpc",
								"xmlwriter",
								"xsl",
								"Zend OPcache",
								"zip",
								"zlib",
								"wordpress",
								"phpunit",
							},
							diagnostics = {
								enable = true,
							},
						},
					},
				})
			end,
			["jsonls"] = function()
				local default_schemas = nil
				local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
				if status_ok then
					default_schemas = jsonls_settings.get_default_schemas()
				end

				local schemas = {
					{
						description = "TypeScript compiler configuration file",
						fileMatch = {
							"tsconfig.json",
							"tsconfig.*.json",
						},
						url = "https://json.schemastore.org/tsconfig.json",
					},
					{
						description = "Lerna config",
						fileMatch = { "lerna.json" },
						url = "https://json.schemastore.org/lerna.json",
					},
					{
						description = "Babel configuration",
						fileMatch = {
							".babelrc.json",
							".babelrc",
							"babel.config.json",
						},
						url = "https://json.schemastore.org/babelrc.json",
					},
					{
						description = "ESLint config",
						fileMatch = {
							".eslintrc.json",
							".eslintrc",
						},
						url = "https://json.schemastore.org/eslintrc.json",
					},
					{
						description = "Bucklescript config",
						fileMatch = { "bsconfig.json" },
						url = "https://raw.githubusercontent.com/rescript-lang/rescript-compiler/8.2.0/docs/docson/build-schema.json",
					},
					{
						description = "Prettier config",
						fileMatch = {
							".prettierrc",
							".prettierrc.json",
							"prettier.config.json",
						},
						url = "https://json.schemastore.org/prettierrc",
					},
					{
						description = "Vercel Now config",
						fileMatch = { "now.json" },
						url = "https://json.schemastore.org/now",
					},
					{
						description = "Stylelint config",
						fileMatch = {
							".stylelintrc",
							".stylelintrc.json",
							"stylelint.config.json",
						},
						url = "https://json.schemastore.org/stylelintrc",
					},
					{
						description = "A JSON schema for the ASP.NET LaunchSettings.json files",
						fileMatch = { "launchsettings.json" },
						url = "https://json.schemastore.org/launchsettings.json",
					},
					{
						description = "Schema for CMake Presets",
						fileMatch = {
							"CMakePresets.json",
							"CMakeUserPresets.json",
						},
						url = "https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json",
					},
					{
						description = "Configuration file as an alternative for configuring your repository in the settings page.",
						fileMatch = {
							".codeclimate.json",
						},
						url = "https://json.schemastore.org/codeclimate.json",
					},
					{
						description = "LLVM compilation database",
						fileMatch = {
							"compile_commands.json",
						},
						url = "https://json.schemastore.org/compile-commands.json",
					},
					{
						description = "Config file for Command Task Runner",
						fileMatch = {
							"commands.json",
						},
						url = "https://json.schemastore.org/commands.json",
					},
					{
						description = "AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.",
						fileMatch = {
							"*.cf.json",
							"cloudformation.json",
						},
						url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json",
					},
					{
						description = "The AWS Serverless Application Model (AWS SAM, previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs, AWS Lambda functions, and Amazon DynamoDB tables needed by your serverless application.",
						fileMatch = {
							"serverless.template",
							"*.sam.json",
							"sam.json",
						},
						url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json",
					},
					{
						description = "Json schema for properties json file for a GitHub Workflow template",
						fileMatch = {
							".github/workflow-templates/**.properties.json",
						},
						url = "https://json.schemastore.org/github-workflow-template-properties.json",
					},
					{
						description = "golangci-lint configuration file",
						fileMatch = {
							".golangci.toml",
							".golangci.json",
						},
						url = "https://json.schemastore.org/golangci-lint.json",
					},
					{
						description = "JSON schema for the JSON Feed format",
						fileMatch = {
							"feed.json",
						},
						url = "https://json.schemastore.org/feed.json",
						versions = {
							["1"] = "https://json.schemastore.org/feed-1.json",
							["1.1"] = "https://json.schemastore.org/feed.json",
						},
					},
					{
						description = "Packer template JSON configuration",
						fileMatch = {
							"packer.json",
						},
						url = "https://json.schemastore.org/packer.json",
					},
					{
						description = "NPM configuration file",
						fileMatch = {
							"package.json",
						},
						url = "https://json.schemastore.org/package.json",
					},
					{
						description = "JSON schema for Visual Studio component configuration files",
						fileMatch = {
							"*.vsconfig",
						},
						url = "https://json.schemastore.org/vsconfig.json",
					},
					{
						description = "Resume json",
						fileMatch = { "resume.json" },
						url = "https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json",
					},
				}

				-- configure json language server
				lspconfig["jsonls"].setup({
					capabilities = capabilities,
					settings = {
						json = {
							schemas = vim.tbl_extend("keep", default_schemas or {}, schemas),
						},
					},
				})
			end,
		})
	end,
}
