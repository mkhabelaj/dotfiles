-- ~/.config/nvim/lua/plugins/mason.lua
return {
	{
		"williamboman/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Mason",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			-- 1) Mason core
			require("mason").setup(opts)

			-- 2) LSP servers
			require("mason-lspconfig").setup({
				ensure_installed = {
					"tsserver",
					"html",
					"cssls",
					"tailwindcss",
					"lua_ls",
					"emmet_ls",
					"pyright",
					"jsonls",
					"intelephense",
					"gopls",
					"volar",
				},
				automatic_installation = true,
			})

			-- 3) Extra tools
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"isort",
					"black",
					"ruff",
					"eslint_d",
					"phpcs",
					"php-cs-fixer",
					"stylelint",
					"goimports-reviser",
					"gofumpt",
					"golines",
					"delve",
				},
			})

			-- 4) Buffer-local LSP mappings on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local wk = require("which-key")
					wk.add({
						{ "<leader>l", buffer = ev.buf, group = "LSP" },
						{ "<leader>lR", ":LspRestart<CR>", buffer = ev.buf, desc = "Restart LSP" },
						{ "<leader>ld", buffer = ev.buf, group = "Diagnostics" },
						{ "<leader>ldj", vim.diagnostic.goto_next, buffer = ev.buf, desc = "Next diagnostic" },
						{ "<leader>ldk", vim.diagnostic.goto_prev, buffer = ev.buf, desc = "Prev diagnostic" },
						{ "<leader>ldl", vim.diagnostic.open_float, buffer = ev.buf, desc = "Line diagnostics" },
						{ "<leader>ll", vim.diagnostic.open_float, buffer = ev.buf, desc = "Line diagnostics" },
						{ "<leader>lo", "<cmd>Lspsaga outline<CR>", buffer = ev.buf, desc = "Outline" },
						{ "<leader>lr", vim.lsp.buf.rename, buffer = ev.buf, desc = "Rename" },
						{
							mode = { "n", "v" },
							{ "<leader>la", vim.lsp.buf.code_action, buffer = ev.buf, desc = "Code action" },
						},
					})
					wk.add({
						{ "gl", "<cmd>Lspsaga peek_definition<CR>", buffer = ev.buf, desc = "Peek definition" },
						{ "gF", "<cmd>Lspsaga finder<CR>", buffer = ev.buf, desc = "References" },
						{ "K", vim.lsp.buf.hover, buffer = ev.buf, desc = "Hover docs" },
					})
				end,
			})

			-- 5) Hook into nvim-lspconfig
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")
			local caps = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				-- default handler
				function(server_name)
					lspconfig[server_name].setup({ capabilities = caps })
				end,

				-- volar (Vue)
				["volar"] = function()
					lspconfig.volar.setup({
						capabilities = caps,
						filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" },
						init_options = { vue = { hybridMode = true } },
					})
				end,

				-- gopls (Go)
				["gopls"] = function()
					lspconfig.gopls.setup({
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
					})
				end,

				-- emmet_ls
				["emmet_ls"] = function()
					lspconfig.emmet_ls.setup({
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
					})
				end,

				-- lua_ls (Neovim Lua)
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = caps,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								completion = { callSnippet = "Replace" },
							},
						},
					})
				end,

				-- pyright (Python)
				["pyright"] = function()
					lspconfig.pyright.setup({
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
					})
				end,

				-- intelephense (PHP)
				["intelephense"] = function()
					lspconfig.intelephense.setup({
						capabilities = caps,
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
									"exif",
									"fileinfo",
									"filter",
									"ftp",
									"gd",
									"hash",
									"iconv",
									"imap",
									"intl",
									"json",
									"libxml",
									"mbstring",
									"oci8",
									"odbc",
									"openssl",
									"phar",
									"pdo",
									"pdo_mysql",
									"pdo_pgsql",
									"pdo_sqlite",
									"pgsql",
									"soap",
									"sockets",
									"sodium",
									"sqlite3",
									"standard",
									"tokenizer",
									"xml",
									"xmlreader",
									"xmlrpc",
									"xmlwriter",
									"yaml",
									"zip",
									"zlib",
									"wordpress",
									"phpunit",
								},
								diagnostics = { enable = true },
							},
						},
					})
				end,

				-- jsonls (JSON)
				["jsonls"] = function()
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
						-- add more schemas here…
					}
					lspconfig.jsonls.setup({
						capabilities = caps,
						settings = { json = { schemas = vim.tbl_extend("keep", default_schemas or {}, schemas) } },
					})
				end,
			})
		end,
	},
}
